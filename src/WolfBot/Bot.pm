use warnings;
use strict;
use diagnostics;

package WolfBot::Bot;
use base qw(Bot::BasicBot);
use Pithub;
use Data::Dumper;

my @ops = [];
my $auth_password = '';

#My said subroutine
sub said {
  #get some args
  my ($self, $message) = @_;
  my $body = $message->{body};
  my $nick = $message->{who};
  my $who = $message->{raw_nick};

  if ($body =~ m/^\@/) {
    my ($activation, $command) = split(/^@/, $body);

    if ($command =~ m/^auth\s.+/) {
      my ($auth, $pass) = split (/^auth\s/, $command);

      if ($pass eq $auth_password) {
        $self->say(
        channel => $message->{channel},
        who     => $nick,
        body    => $nick . ', you have been added to the list of ops'
        );
        push(@ops, $who);
      } else {
        $self->say(
        channel => $message->{channel},
        who     => $nick,
        body    => $nick . ', that is not the correct password'
        );
      }
    } elsif ($command =~ m/^auth\s*/) {
      this_command_needs_args('auth', 1, $message, $self);
    }

    #op commands
    foreach my $op (@ops) {
      if ($who eq $op) {
        #quit command
        if ($command eq 'quit') {
          $self->shutdown;
        }

        #part command
        if ($command =~ m/^part\s.+/) {
          my ($part, $part_chan) = split(/^part\s/, $command);

          $self->part($part_chan);

        } elsif ($command =~ m/^part\s*/) {
          this_command_needs_args('part', 1, $message, $self);
        }

        #join command
        if ($command =~ m/^join\s.+/) {
          my ($join, $join_chan) = split(/^join\s/, $command);

          $self->join($join_chan);

        } elsif ($command =~ m/^join\s*/) {
          this_command_needs_args('join', 1, $message, $self);
        }
      }
    }
    #host command
    if ($command eq 'host') {
      $self->say(
      channel => $message->{channel},
      body    => $nick . ', your host is ' . $who
      );
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
    } elsif ($command =~ m/^say\s*/) {
      this_command_needs_args("say", 1, $message, $self);
    }

    #kill command
    if ($command =~ m/^kill\s.+/) {
      my ($kill, $what_to_kill) = split(/^kill\s/, $command);

      $self->emote(
      channel => $message->{channel},
      body    => ('Terminates ' . $what_to_kill)
      );
    } elsif ($command =~ m/^kill\s*/) {
      this_command_needs_args("kill", 1, $message, $self)
    }

    #help command
    if ($command eq 'help') {
      $self->say(
      channel => $message->{channel},
      body    => ('My activation character is @ and I can do these commands: github, help, say, kill, cookie, action, and host. I can also do part, join, and quit if the person is Strikingwolf')
      );
    }

    #The action command
    if ($command =~ m/^action\s.+/) {
      my ($action, $action_to_do) = split(/action\s/, $command);

      $self->emote(
      channel => $message->{channel},
      body    => $action_to_do
      );
    } elsif ($command =~ m/^action\s*/) {
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
    } elsif ($command =~ m/^cookie\s*/) {
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

  if ($body =~ m/\@$self->{nick}/) {
    $self->say(
    channel => $message->{channel},
    body    => ('What do you need ' . $nick)
    );
  }

}

sub init {
 $auth_password = prompt("Password for OP: \n");
 return 1;
}

sub this_command_needs_args {
  my ($command_name, $how_many, $message_to_respond_to, $self) = @_;
  $self->say(
  channel => $message_to_respond_to->{channel},
  body    => $message_to_respond_to->{who} . " " . $command_name . " needs " . $how_many . " arguments separated by whitespace"
  );
}

sub prompt {
  my ($text) = @_;
  print $text;

  my $answer = <STDIN>;
  chomp $answer;
  return $answer;
}

1;
