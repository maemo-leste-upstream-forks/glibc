ifeq ($(DEB_HOST_ARCH),$(DEB_BUILD_ARCH))
CC     = gcc-4.3
CXX    = g++-4.3
endif

libc = libc6.1
