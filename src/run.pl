#!usr/bin/env perl

use v5.20.1;
use warnings;
use strict;
use diagnostics;
use WolfBot::Bot;
use Bot::BasicBot;

our $chan = '#ItsAnimeTime';

our $bot = WolfBot::Bot->new(
  server    => 'irc.esper.net',
  port      => '6667',
  channels  => [$chan],

  nick      => 'WolfBot',
  alt_nicks => ['TheWolfBot', 'StrikingBot'],
  username  => 'WolfBot',
  name      => 'Strikingwolf\'s IRC bot'
);

$bot->run();
