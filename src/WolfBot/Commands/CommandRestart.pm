use warnings;
use strict;
use diagnostics;

use WolfBot::Run;

package WolfBot::Commands::CommandRestart;

sub new {
  my ($class, %args) = @_;
  return bless { %args }, $class;
}

sub run {
  my ($self, $bot, $bot_vars, $message) = @_;

  if ($message->{body} =~ m/^\@/) {
    my ($activation, $command) = split(/^@/, $message->{body});
    my $nick = $message->{who};
    my ($throway, $person) = split(/^$nick/, $message->{raw_nick});

    foreach my $op (@{$bot_vars->{ops}}) {
      if ($person eq $op) {
        if ($command eq 'restart') {
          $bot->say(
          channel => $message->{channel},
          who     => $nick,
          body    => 'Restarting'
          );
          WolfBot::Run->restart($bot, $bot_vars->{auth_password});
        }
      }
    }
  }
}
1;
