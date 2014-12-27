#!usr/bin/perl

use warnings;
use strict;
use diagnostics;

use WolfBot::Bot;
use Bot::BasicBot;

my @chans = ['#ItsAnimeTime', '#FTB-Wiki', '#wamm_bots'];
my $password = prompt("Password:\n");

my $bot = WolfBot::Bot->new(
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
