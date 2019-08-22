#!/usr/bin/perl
#
# This file is part of Redis
#
# This software is Copyright (c) 2013 by Pedro Melo, Damien Krotkine.
#
# This is free software, licensed under:
#
#   The Artistic License 2.0 (GPL Compatible)
#

use strict;
use warnings;
use IO::Socket::INET;

$| = 1;
my $sock = IO::Socket::INET->new(
    Listen    => 5,
    LocalAddr => 'localhost',
    LocalPort => 1234,
    Proto     => 'tcp',
    ReuseAddr => 1,
);

die $! unless $sock;
die $! unless $sock->listen();

while (my $client = $sock->accept()) {
    my $line = <$client>;
    chomp $line;

    my ($cnt, $len) = split(',', $line);
    next unless $cnt || $len;

    for (my $i = 1; $i <= $cnt; ++$i) {
        print $client '.' x $len, "\n";
    }
}
