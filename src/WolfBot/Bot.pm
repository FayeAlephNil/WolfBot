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
    my $what_to_say = split(/\s/, $body);

    #say it
    $self->say(
      channel => $message->{channel},
      body    => $what_to_say
    );
  }
}
1;
