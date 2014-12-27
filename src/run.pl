#!usr/bin/perl

use warnings;
use strict;
use diagnostics;

use WolfBot::Bot;
use Bot::BasicBot;

our @chans = ['#ItsAnimeTime', '#FTB-Wiki', '#wamm_bots'];
our $password = prompt("Password:\n");

our $bot = WolfBot::Bot->new(
server    => 'irc.esper.net',
port      => '6667',
channels  => @chans,

nick      => 'StrikingwolfBot',
password  => $password,
alt_nicks => ['TheWolfBot', 'StrikingBot'],
username  => 'StrikingwolfBot',
name      => 'Strikingwolfs\'s IRC bot'
);

$bot->run();

sub prompt {
  my ($text) = @_;
  print $text;

  my $answer = <STDIN>;
  chomp $answer;
  return $answer;
}
