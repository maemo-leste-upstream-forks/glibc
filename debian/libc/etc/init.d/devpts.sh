#! /bin/sh

set -e

. /etc/default/devpts

[ "`uname -s`" = "Linux" ] || exit 0

#
#	First find out if devpts is available. Also check if devfs
#	is already mounted - in that case we don't want to use devpts.
#
#	As of 2.5.68, devpts is not automounted when using devfs.
#	So even in that case, devpts needs to be mounted via the
#	devpts.sh script as well as the case that devfs is not used.
#
devpts_avail=`grep -ci '[<[:space:]]devpts' /proc/filesystems || true`
devpts_mounted=`grep -ci '/dev/pts' /proc/mounts || true`
devfs_mounted=`grep -ci '[<[:space:]]/dev[>[:space:]].*devfs' /proc/mounts || true`
kernel_ver=`uname -r`

prepare_and_mount() {
	#
	#	Create mountpoint and multiplexor device.
	#
	[ -d /dev/pts ] || mkdir --mode=755 /dev/pts
	[ -c /dev/ptmx ] || mknod --mode=666 /dev/ptmx c 5 2

	#
	#	Mount /dev/pts if needed.
	#
	if [ "$devpts_mounted" = 0 ]
	then
		mount -t devpts devpts /dev/pts -ogid=${TTYGRP},mode=${TTYMODE}
	fi
}

if [ "$devpts_avail" != 0 ]
then
	if dpkg --compare-versions "$kernel_ver" ge 2.5.68
	then
		prepare_and_mount
	else
		if [ "$devfs_mounted" = 0 ]
		then
			prepare_and_mount
		fi
	fi
fi
