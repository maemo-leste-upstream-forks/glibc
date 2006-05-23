libc_MIN_KERNEL_SUPPORTED = 2.6.9
libc_add-ons = glibc-ports-2.3.6 linuxthreads $(add-ons)
libc_extra_config_options = $(extra_config_options) --without-tls
