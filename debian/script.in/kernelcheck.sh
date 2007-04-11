kernel_compare_versions () {
    verA=$(($(echo "$1" | sed 's/\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\).*/\1 \* 10000 + \2 \* 100 + \3/')))
    verB=$(($(echo "$3" | sed 's/\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\).*/\1 \* 10000 + \2 \* 100 + \3/')))
    
    test $verA -$2 $verB
}

exit_check () {
    EXIT_CHECK
    exit 1
}

    # Test to make sure z < 255, in x.y.z-n form of kernel version
    # Also make sure we don't trip on x.y.zFOO-n form
    #kernel_rev=$(uname -r | tr -- - . | cut -d. -f3 | tr -d '[:alpha:]')
    kernel_rev=$(uname -r | sed 's/\([0-9]*\.[0-9]*\.\)\([0-9]*\)\(.*\)/\2/')
    if [ "$kernel_rev" -ge 255 ]
    then
        echo WARNING: Your kernel version indicates a revision number
        echo of 255 or greater.  Glibc has a number of built in
        echo assumptions that this revision number is less than 255.
        echo If you\'ve built your own kernel, please make sure that any 
        echo custom version numbers are appended to the upstream
        echo kernel number with a dash or some other delimiter.

        exit_check
    fi

    # sanity checking for the appropriate kernel on each architecture.
    realarch=`uname -m`
    kernel_ver=`uname -r`

    # convert "armv4l" and similar to just "arm", and "mips64" and similar
    # to just "mips"
    case $realarch in
      arm*) realarch="arm";;
      mips*) realarch="mips";;
    esac
    

    # From glibc 2.3.5-7 real-i386 is dropped.
    if [ "$realarch" = i386 ]
    then
	echo WARNING: This machine has real i386 class processor.
	echo Debian etch and later does not support such old hardware
	echo any longer.
	echo The reason is that \"bswap\" instruction is not supported
	echo on i386 class processors, and some core libraries have 
	echo such instruction.  You\'ll see illegal instruction error
	echo when you upgrade your Debian system.
	exit_check
    fi

    # The GNU libc requires 2.6 kernel (except on m68k) because we drop to 
    # support linuxthreads
    if [ "$realarch" != m68k ]
    then
	if kernel_compare_versions "$kernel_ver" lt 2.6.1
	then
	    echo WARNING: POSIX threads library NPTL requires 2.6.1 and
	    echo later kernel.  If you use 2.4 kernel, please upgrade your
	    echo kernel before installing glibc.
	    exit_check
	fi
    fi

    # HPPA boxes require latest fixes in the kernel to function properly.
    if [ "$realarch" = parisc ]
    then
	if kernel_compare_versions "$kernel_ver" lt 2.6.9
	then
	    echo WARNING: This version of glibc requires that you be running
	    echo kernel version 2.6.9 or later.  Earlier kernels contained
	    echo bugs that may render the system unusable if a modern version
	    echo of glibc is installed.
	    exit_check
	fi	
    fi

    # The GNU libc is now built with --with-kernel= >= 2.4.1 on m68k
    if [ "$realarch" = m68k ]
    then
	if kernel_compare_versions "$kernel_ver" lt 2.4.1
	then
	    echo WARNING: This version of glibc requires that you be running
	    echo kernel version 2.4.1 or later.  Earlier kernels contained
	    echo bugs that may render the system unusable if a modern version
	    echo of glibc is installed.
	    exit_check
	fi
    fi

