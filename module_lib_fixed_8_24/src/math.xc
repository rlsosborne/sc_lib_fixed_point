// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include "stdio.h"
#include "mathf8_24.h"
#include "print.h"
#include "xs1.h"

f8_24 fabsf8_24(f8_24 x) {
    if (x < 0) {
        return -x;
    } else {
        return x;
    }
}

f8_24 froundf8_24(f8_24 x) {
    return (x + HALF) & ~(ONE-1);
}

f8_24 mulf8_24(f8_24 a, f8_24 b) {
    int h;
    unsigned l;
    {h, l} = macs(a, b, 0, 1<<((32-MATHF8_24_BITS)*2-1));
    return (h << (32-MATHF8_24_BITS)) | (l >> MATHF8_24_BITS);
}

#define  ldivu(a,b,c,d,e) asm("ldivu %0,%1,%2,%3,%4" : "=r" (a), "=r" (b): "r" (c), "r" (d), "r" (e))

f8_24 divf8_24(f8_24 a, f8_24 b) {
    int sgn = 1;
    unsigned int d, d2, r;
    if (a < 0) {
        sgn = -1;
        a = -a;
    }
    if (b < 0) {
        sgn = -sgn;
        b = -b;
    }
    ldivu(d, r, 0, a, b);
    ldivu(d2, r, r, 0, b);
    
    r = d << MATHF8_24_BITS |
        (d2 + (1<<(31-MATHF8_24_BITS))) >> (32-MATHF8_24_BITS);
    return r * sgn;
}

f8_24 ldexpf8_24(f8_24 a, int exp) {
    if (exp > 0) {
        return a << exp;
    } else if (exp < 0) {
        exp = -exp;
        return (a+(1<<(exp-1))) >> exp;
    } else {
        return a;
    }
}

{f8_24,int} frexpf8_24 (f8_24 d) {
    f8_24 absVal;
    int exp;

    absVal = fabsf8_24(d);
    
    asm("clz %0,%1" : "=r" (exp) : "r" (absVal));
    exp = (32 - MATHF8_24_BITS) - exp;
    
    return {exp < 0 ? d << (-exp) : d >> exp, exp};
}

f8_24 reducef8_24(int ynh, unsigned ynl) {
    if (sext(ynh,MATHF8_24_BITS) == ynh) {
        return (ynh << MATHF8_24_IBITS) | (((unsigned) ynl) >> MATHF8_24_BITS);
    } else if (ynh < 0) {
        return MINF8_24;
    } else {
        return MAXF8_24;
    }
}

