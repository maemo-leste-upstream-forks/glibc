#!/bin/sh -e
#
# This scripts pulls all the .debs in a debian mirror, and extracts testsuite failures, then sorts them.
#
# Copyright © 2007 Pierre Habouzit <madcoder@debian.org>
#
# This script is in the public domain.

[ $# -eq 1 ] && cd "$1"

(mkdir -p debs && cd debs && lftp -e "cd debian/pool/main/g/glibc/; mget -c libc6_*.deb; mget -c libc6.1_*.deb; exit" ftp.debian.org)

to_gnu() {
    dpkg-architecture -a"$1" -qDEB_HOST_GNU_TYPE 2>/dev/null
}

trap "rm -rf here" 0

for i in debs/*.deb; do
    arch="${i##*_}"
    arch="${arch%.deb}"
    version="${i#*_}"
    version="${version%_*}"

    dpkg -x "$i" here
    for log in $(ls here/usr/share/doc/libc6*/log-test-`to_gnu "$arch"`-libc.gz 2>/dev/null); do
        zgrep -e '(Error|Erreur)' "$log" | sed -e '{
            s/^make[^:]*: \** *//g;
            s~^\[.*libc/~~g;
            s~\].*~~g;
        }' | grep -v '^\[' | sort -u > "${arch}_${version}.testsuite"
    done
    rm -rf here
done
