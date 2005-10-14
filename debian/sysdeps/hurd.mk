# This is for the GNU OS.  Commonly known as the Hurd.

GLIBC_OVERLAYS ?= $(shell ls glibc-linuxthreads* glibc-ports* glibc-libidn*)

threads = no
libc = libc0.3
slibdir = /lib

# work around to build, gcc-3.4/gcc-4.0 are not tested yet.
CC = gcc-3.3
BUILD_CC = gcc-3.3

# Glibc should really do this for us.
define libc_extra_install
mkdir -p debian/tmp-$(curpass)/lib
ln -s ld.so.1 debian/tmp-$(curpass)/lib/ld.so
endef

# Do not care about kernel versions for now.
define kernel_check
true
endef

# TLS is broken currently and results in Mach panicing
libc_extra_config_options := $(extra_config_options) --without-tls

