use warnings;
use strict;
use diagnostics;

use WolfBot::Bot;
use Bot::BasicBot;

package WolfBot::Run;

my $backup_pass = undef;

sub run {
  my @chans = ['#Strikingwolf'];
  my $nick = prompt("What do you want the nick to be?\n");
  my $username = prompt("Username:\n");
  my $user_password = prompt("Password:\n");

  my $bot = WolfBot::Bot->new(
  server    => 'irc.esper.net',
  port      => '6667',
  channels  => @chans,

  nick      => $nick,
  password  => $user_password,
  alt_nicks => ['TheWolfBot', 'StrikingBot'],
  username  => $username,
  name      => 'Strikingwolfs\'s IRC bot'
  );

  $bot->run();
}

sub get_backup {
  my $self = shift @_;
  return $backup_pass;
}

sub prompt {
  my ($text) = @_;
  print $text;

  my $answer = <STDIN>;
  chomp $answer;
  return $answer;
}

sub restart {
  my ($self, $bot, $auth_pass) = @_;

  $backup_pass = $auth_pass;
  my $new_nick = $bot->{nick};
  my $poco = $bot->pocoirc();
  my @new_chans = $poco->nick_channels($new_nick);
  my $new_username = $bot->{username};
  my $new_user_password = $bot->{password};

  $bot->shutdown;

  my $new_bot = WolfBot::Bot->new(
  server    => 'irc.esper.net',
  port      => '6667',
  channels  => @new_chans,

  nick      => $new_nick,
  password  => $new_user_password,
  alt_nicks => ['TheWolfBot', 'StrikingBot'],
  username  => $new_username,
  name      => 'Strikingwolfs\'s IRC bot'
  );

  $new_bot->run();
}
1;
