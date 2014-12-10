#!usr/bin/perl

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
name      => 'Strikingwolfs\'s IRC bot'
);

$bot->run();
