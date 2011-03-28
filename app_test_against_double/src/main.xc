// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include "mathf8_24.h"
#include "print.h"

extern int logC(int x);
extern int expC(int x);
extern int sinhC(int x);
extern int coshC(int x);

f8_24 exp2f8_24(f8_24 x);

int tester(int func, int data) {
    switch(func) {
    case 0: return expf8_24(data);
    case 1: return expC(data);
    case 2: return logf8_24(data);
    case 3: return logC(data);
    case 4: return sinhf8_24(data);
    case 5: return sinhC(data);
    case 6: return coshf8_24(data);
    case 7: return coshC(data);
    }
    return MINF8_24;
}

int test(int func, char name[], int min, int max, int minerror, int maxerror) {    
    int hist[31];
    int fail = 0;
    printstr("Testing ");
    printstrln(name);
    for(int k = 0; k < 31; k++) {
        hist[k] = 0;
    }
    for(int k = 0; k <= 256; k++) {
        timer t;
        int t0, t1, t2, t3, z, err, zc;
        int i = min + (((unsigned)(max - min))>>8) * k;
        zc = tester(func|1,i);
        if (zc == MINF8_24) {
            continue;
        }
        z = tester(func,i);
        err = z - zc;
        
        if (err > 15 || err < -15) { // accept error in last bit
            printstr("Error more than 4 bits: ");
            printf8_24(i);
            printstr(" ");
            printf8_24(z);
            printstr(" ");
            printf8_24(zc);
            printstr(" ");
            printf8_24ln(err);
        } else {
            hist[err+15]++;
        }
    }
    printstr("Histogram of errors\n");
    for(int k = 0; k < 31; k++) {
        if (hist[k] != 0) {
            int v = k-15;
            printint(v);
            printstr(" ");
            printf8_24(v);
            printstr(" ");
            if (v < minerror || v > maxerror) {
                printstr("FAIL ");
                fail = 1;
            }
            printintln(hist[k]);
        }
    }
    return fail;
}

int main(void) {
    int fail;
    fail = test(0,"exp", MINF8_24, 4*ONE, -12, 3);
    fail |= test(2,"log", 1, MAXF8_24, 0, 0);
    fail |= test(4,"sinh", -11*ONE>>1, 11*ONE>>1, -4, 4);
    fail |= test(6,"cosh", -11*ONE>>1, 11*ONE>>1, -4, 4);
    return fail;
}