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
# This script is existed for detecting depreciated kernel version to
# check glibc incompatibility.

if [ "`uname -s`" = Linux ]; then
    # glibc kernel version check: KERNEL_VERSION_CHECK
fi

: exit 0
