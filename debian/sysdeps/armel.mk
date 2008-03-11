ifeq ($(DEB_HOST_ARCH),$(DEB_BUILD_ARCH))
CC     = gcc-4.2
CXX    = g++-4.2
endif

libc_add-ons = ports nptl $(add-ons)

# First kernel version that supports EABI
libc_MIN_KERNEL_SUPPORTED = 2.6.14

# Some tests assume a fast machine
TIMEOUTFACTOR=3
