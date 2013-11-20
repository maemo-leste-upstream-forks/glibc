libc_add-ons = ports nptl $(add-ons)

# Passing --disable-profile until arm64 has profiling support
extra_config_options = --disable-profile

# Use gcc-4.8 on arm64, as gcc-4.7 support is a bit sketchy:
CC     = $(DEB_HOST_GNU_TYPE)-$(BASE_CC)-4.8
CXX    = $(DEB_HOST_GNU_TYPE)-$(BASE_CXX)-4.8
