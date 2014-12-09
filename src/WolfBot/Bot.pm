#!/usr/bin/env perl

use v5.20.1;
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

  #check if body is a WolfBot command
  if ($body =~ m/^~/) {
    #get the command
    my $command = split(/~/, $body);

    #quit command
    if ($command eq 'quit') {
      $self->shutdown();
    }

    #say command
    if ($command =~ m/^say/) {
      #get what to say
      my $what_to_say = split(/\s/, $command);

      #say it
      $self->say(
        channel => $message->{channel},
        body    => $what_to_say
      );
    }
  }
}
1;
