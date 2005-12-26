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

    # convert "armv4l" and similar to just "arm"
    case $realarch in
      arm*) realarch="arm";;
    esac

    # intel i386 requires a recent kernel
    if [ "$realarch" = i386 ]
    then
	# From glibc 2.3.5-7 and linux-2.6 2.6.12-1, real-i386 is dropped.
	#if dpkg --compare-versions "$kernel_ver" lt 2.4.24
	#then
	    echo WARNING: This machine has real i386 class processor.
	    echo Debian etch and later does not support such old hardware
	    echo any longer.
	    echo The reason is that \"bswap\" instruction is not supported
	    echo on i386 class processors, and some core libraries have 
	    echo such instruction.  You\'ll see illegal instruction error
	    echo when you upgrade your Debian system.
	    exit_check
	#fi
    fi

    # SPARC sun4m requires a recent kernel
    if [ "$realarch" = sparc ]
    then
	cputype=`egrep '^type.*:.*sun4m' /proc/cpuinfo 2> /dev/null` || true

	if [ "$cputype" != "" ]
	then
	    if dpkg --compare-versions "$kernel_ver" lt 2.4.21
	    then
		echo WARNING: You have a cpu which requires kernel 2.4.21
		echo or greater in order to install this version of glibc.
		echo Please upgrade the kernel before installing this package.
		echo
		echo You should be able to install the latest version of the
		echo sparc kernel-image in order to satisfy this need. You
		echo can also download and compile the latest kernel source
		echo yourself from a kernel mirror \(see http://www.kernel.org/\).
		exit_check
	    fi
	else
	    if dpkg --compare-versions "$kernel_ver" lt 2.2.0 #should be safe
	    then
		echo WARNING: This version of glibc suggests atleast a
		echo 2.2.0 kernel in order to work properly. 2.0.x kernels
		echo will not be able to support certain functions and
		echo may cause problems. 2.2 kernels have proven to be much
		echo more reliable than 2.0.x kernels on the sparc platform
		echo anyway, so an upgrade is suggested. If you have a 2.1.x
		echo kernel is is suggested you upgrade to the latest 2.2
		echo release, since it is more stable and fixes many bugs.
		exit_check
	    fi
	fi
    fi
    # HPPA boxes require latest fixes in the kernel to function properly.
    if [ "$realarch" = parisc ]
    then
	if dpkg --compare-versions "$kernel_ver" lt 2.4.17
	then
		echo WARNING: This version of glibc requires that you be running
		echo atleast a 2.4.17 kernel in order to work properly. Earlier
		echo kernels did not provide the proper functionality in order 
		echo for the system to be stable. 
		exit_check
	fi
    fi
    # parisc64 boxes require latest fixes in the kernel 2.4.19-pa17 or later
    # (in 2.4.x), 2.5.53-pa3 or later (in 2.5.x), to function properly.
    # Note that parisc64 kernel version scheme is "`uname -r`-64".
    if [ "$realarch" = parisc64 ]
    then
	kernel_ver_pa=$(echo "$kernel_ver" | sed 's/pa//')
	if [ "$kernel_ver" = "$kernel_ver_pa" ]
	then
	    if dpkg --compare-versions "$kernel_ver" lt 2.4.19-64
	    then
		echo WARNING: This version of glibc requires that you be
		echo running at least a 2.4.19-64 to work properly.
		echo Earlier kernels did not provide the proper functionality
		echo in order for the system to be stable. 
		exit_check
	    fi
	else
	    if dpkg --compare-versions "$kernel_ver" lt 2.4.19-pa17
	    then
		echo WARNING: This version of glibc requires that you be
		echo running at least a 2.4.19-pa17 in \(2.4\) or 2.5.53-pa3 
		echo \(in 2.5\) to work properly.
		echo Earlier kernels did not provide the proper functionality
		echo in order for the system to be stable. 
		exit_check
	    fi
	fi
    fi

    if [ "$realarch" = mips ] \
	&& [ "`dpkg --print-architecture`" = mips ]
    then
	# MIPS (but not mipsel) require a kernel update for the msq fixes.
	if dpkg --compare-versions "$kernel_ver" lt 2.4.22
	then
		echo WARNING: System V message queues require kernel 2.4.22 to
		echo work correctly on this architecture.  Some programs
		echo "(including perl) may not operate correctly."
		exit_check
	fi
    fi

    # amd64 requires 2.6 kernel because we drop to support linuxthreads
    if [ "$realarch" = x86_64 ] \
	&& [ "`dpkg --print-architecture`" = amd64 ]
    then
	if dpkg --compare-versions "$kernel_ver" lt 2.6.0
	then
	    echo WARNING: POSIX threads library NPTL requires 2.6 and
	    echo later kernel on amd64.  If you use 2.4 kernel, please
	    echo upgrade your kernel before installing glibc.
	    exit_check
	fi
    fi

    # arm requires 2.4 kernel to avoid "obsolete calling standard" problem
    # with sys_llseek
    if [ "$realarch" = arm ] \
	&& [ "`dpkg --print-architecture`" = arm ]
    then
	if dpkg --compare-versions "$kernel_ver" lt 2.4.0
	then
	    echo WARNING: This version of glibc requires that you be running
	    echo kernel version 2.4.0 or later.  Earlier kernels contained
	    echo bugs that may render the system unusable if a modern version
	    echo of glibc is installed.
	    exit_check
	fi
    fi
