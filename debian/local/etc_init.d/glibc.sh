#! /bin/sh -e
#
### BEGIN INIT INFO
# Provides:          glibc
# Required-Start:
# Required-Stop:
# Default-Start:     S
# Default-Stop:
### END INIT INFO
#
# 
# This script detects depreciated kernel versions incompatible with
# the current version of the glibc

if [ "`uname -s`" = Linux ]; then
    # glibc kernel version check: KERNEL_VERSION_CHECK
fi

: exit 0
