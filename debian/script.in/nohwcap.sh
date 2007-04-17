    # Handle upgrades when libc-opt package has been installed.
 
    # Get the list of optimized packages for a given architecture
    case $(dpkg --print-architecture) in
        i386)
            hwcappkgs="libc6-i686 libc6-xen"
            ;;
        kfreebsd-i386)
            hwcappkgs="libc0.1-i686"
            ;;
        sparc)
            hwcappkgs="libc6-sparcv9 libc6-sparcv9b"
            ;;
    esac
 
    # We check the version between the current installed libc and
    # all optimized packages. If they're unmatched, we keep /etc/ld.so.nohwcap
    # file until all optimized packages are installed or removed.
    all_upgraded=yes
    if [ -n "$hwcappkgs" ]; then
        for pkg in $hwcappkgs ; do
            ver=$(dpkg -l $pkg 2>/dev/null | awk '/^i/ { print $3 }')
            if [ -n "$ver" ] && [ "$ver" != "CURRENT_VER" ]; then
                all_upgraded=no
            fi
        done
    fi
    if [ "$all_upgraded" = yes ] ; then
        rm -f /etc/ld.so.nohwcap
    fi
