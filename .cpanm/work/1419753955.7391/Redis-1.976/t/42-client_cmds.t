#!perl
#
# This file is part of Redis
#
# This software is Copyright (c) 2013 by Pedro Melo, Damien Krotkine.
#
# This is free software, licensed under:
#
#   The Artistic License 2.0 (GPL Compatible)
#

use warnings;
use strict;
use Test::More;
use Redis;
use lib 't/tlib';
use Test::SpawnRedisServer;

my ($c, $srv) = redis(requires_version => '2.6.9');
END { $c->() if $c }

subtest 'client_{set|get}name commands' => sub {
  ok(my $r = Redis->new(server => $srv), 'connected to our test redis-server');

  my @clients = $r->client_list;
  is(@clients, 1, 'one client listed');
  like($clients[0], qr/\s+name=\s+/, '... no name set yet');

  is($r->client_setname('my_preccccious'), 'OK',             "client_setname() is supported, no errors");
  is($r->client_getname,                   'my_preccccious', '... client_getname() returns new connection name');

  @clients = $r->client_list;
  like($clients[0], qr/\s+name=my_preccccious\s+/, '... no name set yet');
};


subtest 'client name via constructor' => sub {
  ok(my $r = Redis->new(server => $srv, name => 'buuu'), 'connected to our test redis-server, with a name');
  is($r->client_getname, 'buuu', '...... name was properly set');

  ok($r = Redis->new(server => $srv, name => sub {"cache-for-$$"}), '... with a dynamic name');
  is($r->client_getname, "cache-for-$$", '...... name was properly set');

  ok($r = Redis->new(server => $srv, name => sub {undef}), '... with a dynamic name, but returning undef');
  is($r->client_getname, undef, '...... name was not set');

  my $generation = 0;
  for (1 .. 3) {
    ok($r = Redis->new(server => $srv, name => sub { "gen-$$-" . ++$generation }),
      "Using dynamic name, for generation $generation");
    my $n = "gen-$$-$generation";
    is($r->client_getname, $n, "... name was set properly, '$n'");
  }
};


done_testing();
