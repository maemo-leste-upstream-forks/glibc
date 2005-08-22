# work around to build ppc32/ppc64, gcc-4.0 is not ready.
CC = gcc-3.4
BUILD_CC = gcc-3.4

GLIBC_PASSES += ppc64 nptl
DEB_ARCH_REGULAR_PACKAGES += libc6-ppc64 libc6-dev-ppc64

# nptl/ppc64 extra_cfalgs needs -g2 because of gcc-3.4 bug.
ifeq ($(BUILD_CC_VERSION),3.4)
	nptl_extra_cflags += -g2
	ppc64_extra_cflags += -g2
endif

ppc64_MIN_KERNEL_SUPPORTED = 2.6.0
ppc64_configure_target = powerpc64-linux
ppc64_CC = $(CC) -m64
ppc64_add-ons = nptl $(add-ons)
libc6-ppc64_shlib_dep = libc6-ppc64 (>= $(shlib_dep_ver))
# remove -g1 because of gcc-3.4 problem.  it should be enabled again.
ppc64_extra_cflags = -O3  #-g1
ppc64_LIBDIR = 64
ppc64_extra_config_options := $(extra_config_options) --with-tls --with-__thread --disable-profile
