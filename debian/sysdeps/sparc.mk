GLIBC_PASSES += sparcv9 sparcv9b sparc64
DEB_ARCH_REGULAR_PACKAGES += libc6-sparc64 libc6-sparcv9 libc6-sparcv9b libc6-dev-sparc64
 
sparc64_MIN_KERNEL_SUPPORTED = 2.4.18
sparc64_configure_target=sparc64-linux
sparc64_CC = $(BUILD_CC) -m64
sparc64_extra_cflags = -g1 -O3 -fomit-frame-pointer -D__USE_STRING_INLINES
sparc64_extra_config_options = $(extra_config_options) --disable-profile
sparc64_add-ons = linuxthreads $(add-ons)
libc6-sparc64_shlib_dep = libc6-sparc64 (>= $(shlib_dep_ver))
sparc64_LIBDIR = 64
 
sparcv9_MIN_KERNEL_SUPPORTED = 2.4.18
sparcv9_configure_target=sparcv9-linux
sparcv9_extra_cflags = -g1 -O3 -fomit-frame-pointer -D__USE_STRING_INLINES
sparcv9_extra_config_options = $(extra_config_options) --disable-profile
sparcv9_add-ons = linuxthreads $(add-ons)
sparcv9_LIBDIR = /v9

sparcv9b_MIN_KERNEL_SUPPORTED = 2.4.18
sparcv9b_configure_target=sparcv9b-linux
sparcv9b_extra_cflags = -g1 -O3 -fomit-frame-pointer -D__USE_STRING_INLINES
sparcv9b_extra_config_options = $(extra_config_options) --disable-profile
sparcv9b_add-ons = linuxthreads $(add-ons)
sparcv9b_LIBDIR = /ultra3
