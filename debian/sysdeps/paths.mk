prefix=/usr
bindir=$(prefix)/bin
datadir=$(prefix)/share
includedir=$(prefix)/include
infodir=$(prefix)/share/info
libdir=$(prefix)/lib
docdir=$(prefix)/share/doc
mandir=$(prefix)/share/man
sbindir=$(prefix)/sbin
ifeq ($(DEB_HOST_GNU_SYSTEM),linux)
 libexecdir=$(prefix)/lib
else
 libexecdir=$(prefix)/libexec
endif
