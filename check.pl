#!/usr/bin/env perl

use warnings;
use strict;
use Term::ANSIColor;

my $UNAME_OPTIONS = [
    '-n' => ['>=', 200000, 'nofile'],
];

my $SYSCTL_OPTIONS = [
    'fs.file-max' => ['>=', 5000000],
    'net.core.netdev_max_backlog' => ['>=', 400000],
    'net.core.optmem_max' => ['>=', 10000000],
    'net.core.rmem_default' => ['>=', 10000000],
    'net.core.rmem_max' => ['>=', 10000000],
    'net.core.somaxconn' => ['>=', 65535],
    'net.core.wmem_default' => ['>=', 10000000],
    'net.core.wmem_max' => ['>=', 10000000],
    'net.ipv4.conf.all.rp_filter' => ['==', 1],
    'net.ipv4.conf.default.rp_filter' => ['==', 1],
    'net.ipv4.ip_local_port_range' => ['==', "1024\t65535"],
    'net.ipv4.tcp_congestion_control' => ['==', 'bic'],
    'net.ipv4.tcp_ecn' => ['==', 0],
    'net.ipv4.tcp_max_syn_backlog' => ['>=', 12000],
    'net.ipv4.tcp_max_tw_buckets' => ['>=', 2000000],
    'net.ipv4.tcp_mem' => ['==', "30000000\t30000000\t30000000"],
    'net.ipv4.tcp_rmem' => ['==', "30000000\t30000000\t30000000"],
    'net.ipv4.tcp_sack' => ['==', 1],
    'net.ipv4.tcp_syncookies' => ['==', 0],
    'net.ipv4.tcp_timestamps' => ['==', 1],
    'net.ipv4.tcp_wmem' => ['==', "30000000\t30000000\t30000000"],
    'net.ipv4.tcp_tw_reuse' => ['==', 1],
    'net.ipv4.tcp_fin_timeout', => ['<=', 20],
];

###
# Helpers
###

my $OPERATIONS = {
    '==' => sub { return $_[0] eq $_[1] },
    '!=' => sub { return $_[0] ne $_[1] },
    '<'  => sub { return $_[0] <  $_[1] },
    '<=' => sub { return $_[0] <= $_[1] },
    '>'  => sub { return $_[0] >  $_[1] },
    '>=' => sub { return $_[0] >= $_[1] },
};

sub operator {
    return $OPERATIONS->{$_[0]};
}

sub ok {
    print colored('OK', 'yellow') . "   $_[0]\n";
}

my $failed = 0;
sub fail {
    $failed = 1;
    print STDERR colored('FAIL', 'red') . " $_[0]\n";
}

###
# Ulimit
###

for (my $i = 0; $i < $#{$UNAME_OPTIONS}; $i += 2) {
    my $short = ${$UNAME_OPTIONS}[$i];
    my ($op, $recommended, $long) = @{${$UNAME_OPTIONS}[$i + 1]};
    my $actual=`sh -c "ulimit $short"`;
    chomp($actual);
    if (operator($op)->($actual, $recommended)) {
        ok "ulimit $long $op $recommended ($actual)";
    } else {
        fail "ulimit $long $op $recommended ($actual)";
    }
}

###
# Sysctl
###

for (my $i = 0; $i < $#{$SYSCTL_OPTIONS}; $i += 2) {
    my $option = ${$SYSCTL_OPTIONS}[$i];
    my ($op, $recommended) = @{${$SYSCTL_OPTIONS}[$i + 1]};
    my $actual=`sysctl -n $option`;
    chomp($actual);
    if (operator($op)->($actual, $recommended)) {
        ok "sysctl $option $op $recommended ($actual)";
    } else {
        fail "sysctl $option $op $recommended ($actual)";
    }
}

###
# Exit
###

exit $failed;
