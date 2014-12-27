#!usr/bin/perl

use warnings;
use strict;
use diagnostics;

use WolfBot::Bot;
use Bot::BasicBot;

my @chans = ['#ItsAnimeTime', '#FTB-Wiki', '#wamm_bots'];
my $nick = prompt("What do you want the nick to be?\n")
my $username = prompt("Username:\n")
my $password = prompt("Password:\n");

my $bot = WolfBot::Bot->new(
server    => 'irc.esper.net',
port      => '6667',
channels  => @chans,

nick      => $nick,
password  => $password,
alt_nicks => ['TheWolfBot', 'StrikingBot'],
username  => $username,
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
