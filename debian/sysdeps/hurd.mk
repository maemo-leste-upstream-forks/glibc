# This is for the GNU OS.  Commonly known as the Hurd.
EGLIBC_OVERLAYS ?= $(shell ls glibc-linuxthreads* glibc-ports* glibc-libidn*)
libc = libc0.3

# Linuxthreads Config (we claim "no threads" as nptl keys off this)
threads = no
libc_add-ons = libpthread $(add-ons)
libc_extra_config_options := $(extra_config_options)

# Glibc should really do this for us.
define libc_extra_install
mkdir -p debian/tmp-$(curpass)/lib
ln -s ld.so.1 debian/tmp-$(curpass)/lib/ld.so
endef

# Do not care about kernel versions for now.
define kernel_check
true
endef
