use warnings;
use strict;
use diagnostics;

package WolfBot::Commands::CommandJoinToggle;

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
        if ($command eq 'jointoggle') {
          if ($bot_vars->{spyjoin}) {
            $bot_vars->{spyjoin} = 0;
          } else {
            $bot_vars->{spyjoin} = 1;
          }

          $bot->say(
          channel => $message->{channel},
          body    => 'Joining a channel on spy command toggled',
          who     => $message->{who}
          );
        }
      }
    }
  }
}
1;
