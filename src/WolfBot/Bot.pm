use warnings;
use strict;
use diagnostics;

package WolfBot::Bot;
use base qw(Bot::BasicBot);

#My said subroutine
sub said {
  #get some args
  my ($self, $message) = @_;
  my $body = $message->{body};

  if ($body =~ m/^\*/) {
    my ($activation, $command) = split(/^\*/, $body);

    #quit command
    if ($command eq 'quit') {
      $self->shutdown();
    }

    #say command
    if ($command =~ m/^say/) {
      #get what to say
      my ($say, $what_to_say) = split(/^say\s/, $command);

      #say it
      $self->say(
      channel => $message->{channel},
      body    => $what_to_say
      );
    }

    #kill command
    if ($command =~ m/^kill/) {
      my ($kill, $what_to_kill) = split(/^kill\s/, $command);

      $self->say(
      channel => $message->{channel},
      body    => ('I have terminated ' . $what_to_kill)
      );
    }

    #help command
    if ($command eq 'help') {
      $self->say(
      channel => $message->{channel},
      body    => ('My activation character is * and I can do these commands: help, say, kill, modemteth, and quit')
      );
    }

    #The modemteth command
    if ($command =~ m/^modemteth/) {
      my ($modemteth, $what_to_do_with_teth) = split(/modemteth\s/, $command);

      $self->say(
      channel => $message->{channel},
      body    => '/me ' . $what_to_do_with_teth
      );
    }
  }

}
1;
