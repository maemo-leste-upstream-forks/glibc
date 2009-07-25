#! /bin/sh
#
### BEGIN INIT INFO
# Provides:          glibc
# Required-Start:
# Required-Stop:
# Default-Start:     S
# Default-Stop:
# X-Interactive:     true
# Short-Description: check for deprecated kernel versions
# Description:       This script detects deprecated kernel versions incompatible with
#                    the current version of the glibc
### END INIT INFO
#

set -e

do_start () {

# glibc kernel version check: KERNEL_VERSION_CHECK
}

case "$1" in
	start|"")
		do_start
	        ;;
	restart|reload|force-reload)
		echo "Error: argument '$1' not supported" >&2
		exit 3
		;;
	stop)
		# No-op
		;;
	*)
		echo "Usage: glibc.sh [start|stop]" >&2
		exit 3
		;;
esac

exit 0
