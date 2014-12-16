use warnings;
use strict;
use diagnostics;

package WolfBot::Bot;
use base qw(Bot::BasicBot);
use Pithub;
use Data::Dumper;

#My said subroutine
sub said {
  #get some args
  my ($self, $message) = @_;
  my $body = $message->{body};
  my $nick = $message->{who};
  my $who = $message->{raw_nick};

  if ($body =~ m/^\@/) {
    my ($activation, $command) = split(/^@/, $body);

    #quit command
    if ($command eq 'quit') {
      if ($who eq 'Strikingwolf') {
        $self->shutdown;
      }
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

      $self->emote(
      channel => $message->{channel},
      body    => ('Terminates ' . $what_to_kill)
      );
    }

    #help command
    if ($command eq 'help') {
      $self->say(
      channel => $message->{channel},
      body    => ('My activation character is @ and I can do these commands: github, help, say, kill, cookie, and action')
      );
    }

    #The action command
    if ($command =~ m/^action/) {
      my ($action, $action_to_do) = split(/action\s/, $command);

      $self->emote(
      channel => $message->{channel},
      body    => $action_to_do
      );
    }

    #cookie command
    if ($command =~ m/^cookie/) {
      #get who_to
      my ($say, $who_to) = split(/^cookie\s/, $command);

      #give the cookie it
      $self->say(
      channel => $message->{channel},
      body    => $who_to . ', you got a cookie from ' . $nick
      );
    }

    #github command
    if ($command eq 'github') {
      $self->say(
      channel => $message->{channel},
      body    => 'https://github.com/Strikingwolf/WolfBot'
      );
    }

    #repos command
    if ($command =~ m/^repos/) {
      #get user
      my ($repos, $user) = split(/^repos\s/, $command);

      my $p = Pithub->new;

      my $result = $p->repos->list( user => $user );
      while ( my $row = $result->next ) {
        $self->say(
        channel => $message->{channel},
        body    => $row->{name}
        );
      }
    }
  }

  if ($body =~ m/\@StrikingwolfBot/) {
    $self->say(
    channel => $message->{channel},
    body    => ('What do you need ' . $who)
    );
  }

}
1;
