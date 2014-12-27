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
    if ($command =~ m/^say\s.+/) {
      #get what to say
      my ($say, $what_to_say) = split(/^say\s/, $command);


      #say it
      $self->say(
      channel => $message->{channel},
      body    => $what_to_say
      );
    } elsif ($command =~ m/^say/) {
      this_command_needs_args("say", 1, $message, $self)
    }

    #kill command
    if ($command =~ m/^kill\s.+/) {
      my ($kill, $what_to_kill) = split(/^kill\s/, $command);

      $self->emote(
      channel => $message->{channel},
      body    => ('Terminates ' . $what_to_kill)
      );
    } elsif ($command =~ m/^kill/) {
      this_command_needs_args("kill", 1, $message, $self)
    }

    #help command
    if ($command eq 'help') {
      $self->say(
      channel => $message->{channel},
      body    => ('My activation character is @ and I can do these commands: github, help, say, kill, cookie, and action')
      );
    }

    #The action command
    if ($command =~ m/^action\s.+/) {
      my ($action, $action_to_do) = split(/action\s/, $command);

      $self->emote(
      channel => $message->{channel},
      body    => $action_to_do
      );
    } elsif ($command =~ m/^action/) {
      this_command_needs_args("action", 1, $message, $self)
    }

    #cookie command
    if ($command =~ m/^cookie\s.+/) {
      #get who_to
      my ($say, $who_to) = split(/^cookie\s/, $command);

      #give the cookie it
      $self->say(
      channel => $message->{channel},
      body    => $who_to . ', you got a cookie from ' . $nick
      );
    } elsif ($command =~ m/^cookie/) {
      this_command_needs_args("cookie", 1, $message, $self)
    }

    #github command
    if ($command eq 'github') {
      $self->say(
      channel => $message->{channel},
      body    => 'https://github.com/Strikingwolf/WolfBot'
      );
    }

    #repos command
    #if ($command =~ m/^repos/) {
      #get user
      #my ($repos, $user) = split(/^repos\s/, $command);

      #my $p = Pithub->new;

      #my $result = $p->repos->list( user => $user );
      #while ( my $row = $result->next ) {
        #$self->say(
        #channel => $message->{channel},
        #body    => $row->{name}
        #);
      #}
    #}
  }

  if ($body =~ m/\@StrikingwolfBot/) {
    $self->say(
    channel => $message->{channel},
    body    => ('What do you need ' . $who)
    );
  }

}

sub this_command_needs_args {
  my ($command_name, $how_many, $message_to_respond_to, $self) = @_;
  $self->say(
  channel => $message_to_respond_to->{channel},
  body    => $message_to_respond_to->{who} . " " . $command_name . " needs " . $how_many . " arguments"
  );
}
1;
