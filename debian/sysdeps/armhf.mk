libc_add-ons = ports nptl $(add-ons)

# Use gcc-4.6 on armhf to get correct atomic operations in thumb-2 mode
ifneq ($(DEB_HOST_ARCH),$(DEB_BUILD_ARCH))
CC     = $(DEB_HOST_GNU_TYPE)-gcc
CXX    = $(DEB_HOST_GNU_TYPE)-g++
else
CC     = gcc-4.6
CXX    = g++-4.6
endif

