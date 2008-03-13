libc_add-ons = ports nptl $(add-ons)

# First kernel version that supports EABI
libc_MIN_KERNEL_SUPPORTED = 2.6.14

# Some tests assume a fast machine
TIMEOUTFACTOR=3
