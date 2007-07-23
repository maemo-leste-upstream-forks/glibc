# This is for the GNU OS.  Commonly known as the Hurd.

GLIBC_OVERLAYS ?= $(shell ls glibc-linuxthreads* glibc-ports* glibc-libidn*)

threads = no
libc = libc0.3
slibdir = /lib

# Glibc should really do this for us.
define libc_extra_install
mkdir -p debian/tmp-$(curpass)/lib
ln -s ld.so.1 debian/tmp-$(curpass)/lib/ld.so
endef

# Do not care about kernel versions for now.
define kernel_check
true
endef

libc_extra_config_options := $(extra_config_options)

# Build with gcc-4.2 is not yet tested
CC = gcc-4.1
CXX = g++-4.1
BUILD_CC = gcc-4.1

# Only use libidn as add-on.
standard-add-ons = libidn

# disabled because the testsuite is known to provoke build abortions.
RUN_TESTSUITE = no
