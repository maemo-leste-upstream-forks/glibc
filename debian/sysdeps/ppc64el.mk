libc_rtlddir = /lib64
extra_config_options = --enable-multi-arch
extra_cflags = -O3 -fno-tree-vectorize

# Use gcc-4.8 on ppc64el, as gcc-4.7 support is nonexistent:
CC     = $(DEB_HOST_GNU_TYPE)-$(BASE_CC)-4.8
CXX    = $(DEB_HOST_GNU_TYPE)-$(BASE_CXX)-4.8
