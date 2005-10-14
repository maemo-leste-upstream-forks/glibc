# This is for a Glibc-using FreeBSD system.

GLIBC_OVERLAYS ?= $(shell ls glibc-linuxthreads* glibc-ports* glibc-libidn*)

libc = libc1

# Linuxthreads Config
threads = yes
libc_add-ons = linuxthreads $(add-ons)

extra_config_options = $(extra_config_options) --disable-compatible-utmp --enable-kernel-include=4.6
