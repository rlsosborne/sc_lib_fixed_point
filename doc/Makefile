REPO=../../sc_lib_fixed_point
SPHINX_PROJECT_NAME=Fixed point arithmetic functions
VERSION=0v1
DOXYGEN_DIRS=$(REPO)/module_lib_fixed_8_24 \
		$(REPO)/module_lib_uint_32
SOURCE_INCLUDE_DIRS=$(REPO)
XDOC_DIR ?= ../../xdoc
include $(XDOC_DIR)/Makefile.inc

all: html pdf
	@if [ ! -d $(REPO)_gh_pages ] ; then echo '**** no gh_pages checked out ****'; exit 0; else cp -r _build/html/* $(REPO)_gh_pages/; cp -r _build/html/.doctrees $(REPO)_gh_pages/; echo 'HTML files copied to $(REPO)_gh_pages'; echo 'Now go to $(REPO)_gh_pages, add, commit, and push to publish the documentation'; fi
