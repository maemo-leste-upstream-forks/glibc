# alpha-linux uses 6.1 as libc's soname
ifeq ($(DEB_HOST_GNU_TYPE),alpha-linux)
  libc = libc6.1
else
  ifeq ($(DEB_HOST_GNU_TYPE),ia64-linux)
    libc = libc6.1
  else
    # libc0.3 for hurd
    ifeq ($(DEB_HOST_GNU_SYSTEM),gnu)
      libc = libc0.3
    else
      ifeq ($(DEB_HOST_GNU_SYSTEM),freebsd)
        libc = libc1
      else
        libc = libc6
      endif
    endif
  endif
endif
