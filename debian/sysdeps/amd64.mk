CC = gcc
BUILD_CC = gcc

GLIBC_PASSES += nptl
nptl_extra_cflags = -O3 -fomit-frame-pointer -D__USE_STRING_INLINES

# work around patch for gcc-3.4: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=260710
BUILD_CC_VERSION := $(shell $(BUILD_CC) -dumpversion | sed 's/\([0-9]*\.[0-9]*\)\(.*\)/\1/')
ifeq ($(BUILD_CC_VERSION),3.4)
	nptl_extra_cflags += -g0
endif
