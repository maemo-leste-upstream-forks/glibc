#!/usr/bin/perl

# These get export by debian/sysdeps/depflags.mk
$DEB_HOST_GNU_SYSTEM = $ENV{'DEB_HOST_GNU_SYSTEM'};
$DEB_HOST_GNU_TYPE = $ENV{'DEB_HOST_GNU_TYPE'};
$libc = $ENV{'libc'};
$glibc = $ENV{'glibc'};
@deptypes = ('Depends', 'Replaces', 'Conflicts', 'Provides',
	     'Suggests');

# Let's make sure we are sane
if (!defined($DEB_HOST_GNU_SYSTEM) or !defined($DEB_HOST_GNU_TYPE) or
    !defined($libc) or !defined($glibc)) {
    die "Could not get all parameters";
}

@ARGV == 1 or die "Usage: depflags <type>";
$type = $ARGV[0];

# OS specific stuff
if ($DEB_HOST_GNU_SYSTEM eq "gnu") {
    push @{$libc_dev_c{'Depends'}}, ('gnumach-dev', 'hurd-dev');
    push @{$libc_dev_c{'Replaces'}}, 'glibc2-dev';
    push @{$libc_dev_c{'Conflicts'}}, 'glibc2-dev';
    push @{$libc_c{'Replaces'}}, 'glibc2';
    push @{$libc_c{'Conflicts'}}, 'glibc2';
    push @{$libc_c{'Depends'}}, 'hurd (>= 20010718-1)';
}
if ($DEB_HOST_GNU_SYSTEM eq "linux-gnu") {
    push @{$libc_c{'Suggests'}}, 'locales';
    push @{$libc_dev_c{'Recommends'}}, 'c-compiler';
    push @{$libc_dev_c{'Replaces'}}, ('man-db (<= 2.3.10-41)', 'gettext (<= 0.10.26-1)',
		'ppp (<= 2.2.0f-24)', 'libgdbmg1-dev (<= 1.7.3-24)');
    push @{$libc_dev_c{'Depends'}}, 'linux-libc-dev';
}
if ($DEB_HOST_GNU_SYSTEM eq "kfreebsd-gnu") {
    push @{$libc_c{'Suggests'}}, 'locales';
    push @{$libc_c{'Replaces'}}, 'libc0.1-dev (<< 2.3.2.ds1-14)';
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

# 2.1.94 required a patch, applied in gcc -15, so c++ compiles will work again
push @{$libc_dev_c{'Conflicts'}}, 'libstdc++2.10-dev (<< 1:2.95.2-15)';

# 2.2.2+CVS requires a newer gcc. For non-i386, we just worry about the
# weak-sym patch, since on i386 we need an even newer one because of the
# pic-kludge that breaks libc_nonshared.a inclusion.
if ($DEB_HOST_GNU_TYPE =~ m/^i486-linux-gnu$/) {
    push @{$libc_dev_c{'Conflicts'}}, 'gcc-2.95 (<< 1:2.95.3-9)';
} else {
    push @{$libc_dev_c{'Conflicts'}}, 'gcc-2.95 (<< 1:2.95.3-8)';
}

## Conflict versions of binutils version that does not support DT_GNU_HASH
push @{$libc_dev_c{'Conflicts'}}, 'binutils (<< 2.17cvs20070426-1)';

# Make sure we only have one version of libc-dev installed
push @{$libc_dev_c{'Provides'}}, 'libc-dev';
push @{$libc_dev_c{'Conflicts'}}, 'libc-dev';
if ($libc ne "libc6") {
    push @{$libc_dev_c{'Provides'}}, 'libc6-dev';
}

# Conflict with broken libterm-readline-gnu-perl to avoid #326856.
push @{$libc_c{'Conflicts'}}, 'libterm-readline-gnu-perl (<< 1.15-2)';

# Conflict with older versions of tzdata that need tzconfig.
push @{$libc_c{'Conflicts'}}, 'tzdata (<< 2007e-2)';

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
