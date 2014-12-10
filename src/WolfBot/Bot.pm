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

  #quit command
  if ($body eq '~quit') {
    $self->shutdown();
  }

  #say command
  if ($body =~ m/^~say/) {
    #get what to say
    my ($say, $what_to_say) = split(/^~say\s/, $body);

    #say it
    $self->say(
      channel => $message->{channel},
      body    => $what_to_say
    );
  }

  #kill command
  if ($body =~ m/^~kill/) {
    my ($kill, $what_to_kill) = split(/^~kill\s/, $body);

    $self->say(
    channel => $message->{channel},
    body    => ('I have terminated ' . $what_to_kill)
    );
  }

 #help command
 if ($body =~ m/~help/) {
   $self->say(
   channel => $message->{channel},
   body    => ('My activation character is ~ and I can do these commands: help, say, kill, and quit')
   );
 }
}
1;
