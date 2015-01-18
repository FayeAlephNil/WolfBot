use warnings;
use strict;
use diagnostics;

package WolfBot::Commands::CommandStopSpy;

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
        if ($command eq 'stopspy') {
          for (keys %{$bot_vars->{spyers}})
          {
            delete $bot_vars->{spyers}->{$_};
          }
          $bot->say(
          channel => $message->{channel},
          body    => 'All spying stopped',
          who     => $message->{who}
          );
        }
      }

    }
  }
}
1;
