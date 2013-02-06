libc_add-ons = ports nptl $(add-ons)

# Passing --disable-profile until arm64 has profiling support
extra_config_options = --disable-profile
