libc = libc6.1

# Requires Linux 2.6.9 for NPTL
libc_MIN_KERNEL_SUPPORTED = 2.6.9

# build an ev67 optimized library
GLIBC_PASSES += alphaev67
DEB_ARCH_REGULAR_PACKAGES += libc6.1-alphaev67
alphaev67_MIN_KERNEL_SUPPORTED = 2.6.9
alphaev67_add-ons = nptl $(add-ons)
alphaev67_configure_target = alphaev67-linux
alphaev67_extra_cflags = -mcpu=ev67 -mtune=ev67 -O2
alphaev67_extra_config_options = $(extra_config_options) --disable-profile
alphaev67_rtlddir = /lib
alphaev67_slibdir = /lib/ev67
