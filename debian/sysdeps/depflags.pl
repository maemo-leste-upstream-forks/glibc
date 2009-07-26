#!/usr/bin/perl

# These get export by debian/sysdeps/depflags.mk
$DEB_HOST_ARCH_OS = $ENV{'DEB_HOST_ARCH_OS'};
$DEB_HOST_ARCH = $ENV{'DEB_HOST_ARCH'};
$libc = $ENV{'libc'};
$glibc = $ENV{'glibc'};
@deptypes = ('Depends', 'Replaces', 'Conflicts', 'Provides',
	     'Suggests');

# Let's make sure we are sane
if (!defined($DEB_HOST_ARCH_OS) or !defined($DEB_HOST_ARCH) or
    !defined($libc) or !defined($glibc)) {
    die "Could not get all parameters";
}

@ARGV == 1 or die "Usage: depflags <type>";
$type = $ARGV[0];

# OS specific stuff
if ($DEB_HOST_ARCH_OS eq "hurd") {
    push @{$libc_dev_c{'Depends'}}, ('gnumach-dev', 'hurd-dev (>= 20080607-3)', 'libpthread-stubs0-dev');
    push @{$libc_dev_c{'Replaces'}}, 'glibc2-dev';
    push @{$libc_dev_c{'Conflicts'}}, 'glibc2-dev';
    push @{$libc_c{'Replaces'}}, 'glibc2';
    push @{$libc_c{'Conflicts'}}, 'glibc2';
    push @{$libc_c{'Depends'}}, 'hurd (>= 20070606-1+SVN)';
}
if ($DEB_HOST_ARCH_OS eq "linux") {
    push @{$libc_c{'Suggests'}}, 'locales';
    push @{$libc_dev_c{'Recommends'}}, 'c-compiler';
    push @{$libc_dev_c{'Depends'}}, 'linux-libc-dev';
}
if ($DEB_HOST_ARCH_OS eq "kfreebsd") {
    push @{$libc_c{'Suggests'}}, 'locales';
    push @{$libc_dev_c{'Recommends'}}, 'c-compiler';
    push @{$libc_dev_c{'Replaces'}}, 'kfreebsd-kernel-headers (<< 0.11)';
    push @{$libc_dev_c{'Depends'}}, 'kfreebsd-kernel-headers (>= 0.11)';
}

# ${glibc}-doc is suggested by $libc_c and $libc_dev_c.
push @{$libc_c{'Suggests'}}, "${glibc}-doc";
push @{$libc_dev_c{'Suggests'}}, "${glibc}-doc";
push @{$libc_dev_c{'Suggests'}}, "manpages-dev";

# nss-db is now seperate
push @{$libc_c{'Recommends'}}, 'libnss-db';

## Conflict versions of binutils version that does not support DT_GNU_HASH
push @{$libc_dev_c{'Conflicts'}}, 'binutils (<< 2.17cvs20070426-1)';

# Make sure we only have one version of libc-dev installed
push @{$libc_dev_c{'Provides'}}, 'libc-dev';
push @{$libc_dev_c{'Conflicts'}}, 'libc-dev';
if ($libc ne "libc6") {
    push @{$libc_dev_c{'Provides'}}, 'libc6-dev';
}

# Conflict with older versions of tzdata that need tzconfig.
push @{$libc_c{'Conflicts'}}, 'tzdata (<< 2007k-1), tzdata-etch';

# Conflict with older versions of nscd
push @{$libc_c{'Conflicts'}}, 'nscd (<< 2.9)';

# Depends on libgcc1/libgcc2/libgcc4
if ($DEB_HOST_ARCH =~ m/^hppa$/) {
    push @{$libc_c{'Depends'}}, 'libgcc4';
} elsif ($DEB_HOST_ARCH =~ m/^m68k$/) {
    push @{$libc_c{'Depends'}}, 'libgcc2';
} else {
    push @{$libc_c{'Depends'}}, 'libgcc1';
}

if ($type eq "libc") {
    %pkg = %libc_c;
} elsif ($type eq "libc_dev") {
    %pkg = %libc_dev_c;
} else {
    die "Unknown package $type";
}

foreach $dep (@deptypes) {
    next if not defined($pkg{$dep});
    print "-D${dep}=\"" . join(', ', @{$pkg{$dep}}) . "\" ";
}
