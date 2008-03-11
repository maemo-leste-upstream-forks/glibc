ifeq ($(DEB_HOST_ARCH),$(DEB_BUILD_ARCH))
CC     = gcc-4.2
CXX    = g++-4.2
endif

libc_add-ons = ports nptl $(add-ons)

# We need __ARM_NR_set_tls syscall
libc_MIN_KERNEL_SUPPORTED = 2.6.12

# Some tests assume a fast machine
TIMEOUTFACTOR=4
