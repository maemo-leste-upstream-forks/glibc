# This is for the GNU OS.  Commonly known as the Hurd.

GLIBC_OVERLAYS ?= $(shell ls glibc-linuxthreads* glibc-ports* glibc-libidn*)

threads = no
libc = libc0.3
slibdir = /lib

# udeb Config
#udeb_extra_cflags = -Os
udeb_extra_config_options := $(extra_config_options) --without-tls libc_cv_z_relro=no

# Glibc should really do this for us.
define libc_extra_install
mkdir -p debian/tmp-$(curpass)/lib
ln -s ld.so.1 debian/tmp-$(curpass)/lib/ld.so
endef

# Do not care about kernel versions for now.
define kernel_check
true
endef

# TLS is broken currently and results in Mach panicing.
# ld.so is broken currently if z_relro is used.
libc_extra_config_options := $(extra_config_options) --without-tls libc_cv_z_relro=no

