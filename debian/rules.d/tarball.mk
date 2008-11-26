GLIBC_PSERVER = :pserver:anoncvs@sources.redhat.com:/cvs/glibc
GLIBC_TAG = glibc-$(subst .,_,$(GLIBC_VERSION))
GLIBC_DIR = glibc-$(GLIBC_VERSION)
DEB_ORIG = ../glibc_$(GLIBC_VERSION).orig.tar.gz

get-orig-source: $(DEB_ORIG)
$(DEB_ORIG):
	cvs -z 9 -d $(GLIBC_PSERVER) export -d $(GLIBC_DIR) -r $(GLIBC_TAG) libc ; \
	cd $(GLIBC_DIR) ; \
	rm -fr manual/ ; \
	cvs -z 9 -d $(GLIBC_PSERVER) export -d ports -r $(GLIBC_TAG) ports ; \
	cvs -z 9 -d $(GLIBC_PSERVER) export -d linuxthreads -r HEAD linuxthreads/linuxthreads ; \
	cvs -z 9 -d $(GLIBC_PSERVER) export -d linuxthreads_db -r HEAD linuxthreads/linuxthreads_db ; \
	cd .. ; \
	tar -zcf $(DEB_ORIG) $(GLIBC_DIR) ; \
	rm -rf $(GLIBC_DIR)
