CC = gcc
BUILD_CC = gcc

# build libc with nptl instead of linuxthreads
libc_MIN_KERNEL_SUPPORTED = 2.6.0
libc_add-ons = nptl $(add-ons)
libc_extra_cflags = -O3
libc_extra_config_options := $(extra_config_options) --with-tls --with-__thread

# work around patch for gcc-3.4: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=260710
BUILD_CC_VERSION := $(shell $(BUILD_CC) -dumpversion | sed 's/\([0-9]*\.[0-9]*\)\(.*\)/\1/')
ifeq ($(BUILD_CC_VERSION),3.4)
	libc_extra_cflags += -g0
endif
