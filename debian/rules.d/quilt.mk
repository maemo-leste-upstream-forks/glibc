# Implements the patch and unpatch targets, called when building packages.
# $(stamp)patch-log/$(stamp)unpatch-log contain logs.

# -*- Makefile -*-, you silly Emacs!
# vim: set ft=make:

patch: $(stamp)unpack quilt
	@cd $(DEB_SRCDIR); \
	if quilt next >/dev/null 2>&1; then \
	  echo -n "Applying patches..."; \
	  if quilt push -a -v > ${stamp}patch-log 2>&1; then \
	    echo "successful."; \
	  else \
	    echo "failed! (check ${stamp}patch-log for details)"; \
	    exit 1; \
	  fi; \
	else \
	  echo "No patches to apply"; \
	fi

#  By default, quilt looks for patches in the patches/ directory.
#  Debian maintainers often set QUILT_PATCHES="debian/patches"
#  in their $HOME/.quiltrc
#  These symbolic links are useful when running quilt interactively
#  from $(DEB_SRCDIR), or from the patch/unpatch targets.
quilt: 
	@if test -n "$(DEB_SRCDIR)" && test -d $(DEB_SRCDIR); then \
	  test -L $(DEB_SRCDIR)/debian || ln -s . $(DEB_SRCDIR)/debian; \
	  test -L $(DEB_SRCDIR)/patches || ln -s $(shell pwd)/debian/patches $(DEB_SRCDIR)/patches; \
	fi

unpatch: quilt
	@echo -n "Unapplying patches..."
	@cd $(DEB_SRCDIR); \
	if quilt top >/dev/null 2>&1; then \
	  if quilt pop -a -v > $(stamp)unpatch-log 2>&1; then \
	    echo "successful."; \
	  else \
	    echo "failed! (check $(stamp)unpatch-log for details)"; \
	    exit 1; \
	  fi; \
	else \
	  echo "nothing to do."; \
	fi
	rm -f $(stamp)patch-log $(stamp)unpatch-log

