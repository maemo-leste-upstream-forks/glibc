libc_add-ons = ports nptl $(add-ons)

# gcc-4.7 explodes on ia64, so use gcc-4.6 for now
CC = $(DEB_HOST_GNU_TYPE)-$(BASE_CC)-4.6
CXX = $(DEB_HOST_GNU_TYPE)-$(BASE_CXX)-4.6

libc = libc6.1
