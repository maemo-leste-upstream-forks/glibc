GLIBC_PSERVER = :pserver:anoncvs@sources.redhat.com:/cvs/glibc
GLIBC_BRANCH = glibc-$(subst .,_,$(GLIBC_VERSION))-branch
GLIBC_SNAPSHOT = $(GLIBC_VERSION)+$(shell date "+%Y%m%d")
GLIBC_DIR = glibc-$(GLIBC_SNAPSHOT)
DEB_ORIG = ../glibc_$(GLIBC_SNAPSHOT).orig.tar.gz

get-orig-source: $(DEB_ORIG)
$(DEB_ORIG):
	cvs -z 9 -d $(GLIBC_PSERVER) export -d $(GLIBC_DIR) -r $(GLIBC_BRANCH) libc ; \
	cd $(GLIBC_DIR) ; \
	rm -fr manual/ ; \
	cvs -z 9 -d $(GLIBC_PSERVER) export -d ports -r $(GLIBC_BRANCH) ports ; \
	cvs -z 9 -d $(GLIBC_PSERVER) export -d linuxthreads -r HEAD linuxthreads/linuxthreads ; \
	cvs -z 9 -d $(GLIBC_PSERVER) export -d linuxthreads_db -r HEAD linuxthreads/linuxthreads_db ; \
	cd .. ; \
	tar -zcf $(DEB_ORIG) $(GLIBC_DIR) ; \
	rm -rf $(GLIBC_DIR)
