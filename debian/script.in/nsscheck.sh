	    echo -n "Checking for services that may need to be restarted..."
	    # Only get the ones that are installed, and configured
	    check=$(dpkg -s $check 2> /dev/null | egrep '^Package:|^Status:' | awk '{if ($1 ~ /^Package:/) { package=$2 } else if ($0 ~ /^Status: .* installed$/) { print package }}')
	    # some init scripts don't match the package names
	    check=$(echo $check | \
	    	    sed -e's/\bapache2-common\b/apache2/g' \
	    	    	-e's/\bat\b/atd/g' \
	    	    	-e's/\bdovecot-common\b/dovecot/g' \
	    	    	-e's/\bexim4-base\b/exim4/g' \
	    	    	-e's/\blpr\b/lpd/g' \
	    	    	-e's/\blpr-ppd\b/lpd-ppd/g' \
	    	    	-e's/\bsasl2-bin\b/saslauthd/g' \
	    )
	    echo
	    echo "Checking init scripts..."
	    rl=$(runlevel | sed 's/.*\ //')
	    for service in $check; do
	    	if [ -x "`which invoke-rc.d 2>/dev/null`" ]; then
	    	    idl=$(ls /etc/init.d/${service} 2> /dev/null | head -n 1)
	    	    if [ -n "$idl" ] && [ -x $idl ]; then
	    	    	services="$service $services"
	    	    else
	    	    	echo "WARNING: init script for $service not found."
	    	    fi
	    	else
	    	    if [ -f /usr/share/file-rc/rc ] || [ -f /usr/lib/file-rc/rc ] && [ -f /etc/runlevel.conf ]; then
	    	    	idl=$(filerc $rl $service)
	    	    else
	    	    	idl=$(ls /etc/rc${rl}.d/S??${service} 2> /dev/null | head -1)
	    	    fi
	    	    if [ -n "$idl" ] && [ -x $idl ]; then
	    	    	services="$service $services"
	    	    fi
	    	fi
	    done
