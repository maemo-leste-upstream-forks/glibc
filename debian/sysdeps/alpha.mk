libc = libc6.1

# disabled because alpha linuxthreads ex7, ex9, ex10, ex18 stopps eternally
# even if TIMEOUTSCALE is set - SIGALRM from the program is just ignored.
RUN_TESTSUITE = no

# disabled for static linked pthread programs.
libc_extra_config_options = $(extra_config_options) --with-tls --without-__thread
