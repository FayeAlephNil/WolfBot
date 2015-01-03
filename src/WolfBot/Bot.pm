use warnings;
use strict;
use diagnostics;

package WolfBot::Bot;
use base qw(Bot::BasicBot);
use Pithub;
use LWP::Simple;
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
  my $pocoirc = $self->pocoirc();

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
        my ($throway, $new_op) = split(/^$nick!/);
        push(@ops, $new_op);
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
      if ($who =~ m/$op$/) {
        #quit command
        if ($command eq 'quit') {
          $self->shutdown;
        }

        #part command
        if ($command =~ m/^part\s.+/) {
          my ($part, $part_chan) = split(/^part\s/, $command);

          $self->part($part_chan);

        } elsif ($command =~ m/^part\s*/) {
          $self->part($message->{channel})
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

    #channel owner commands
    if ($pocoirc->is_channel_operator($message->{channel}, $nick)) {
      if ($command eq 'leave') {
        $self->part($message->{channel});
      }
    }

    #drama command
    if ($command eq 'drama') {
      my $drama_url = "http://asie.pl/drama.php?2&plain";
      my $content = get($drama_url);
      my $drama = substr($content, 0, index($content, '<'));
      my $purged_drama = '';

      my $char_counter = 1;
      foreach my $char (split(//, $drama)) {
        if ($char_counter % 3 == 0) {
          $purged_drama = $purged_drama . "\x{200b}" . $char;
        } else {
          $purged_drama = $purged_drama . $char;
        }

        $char_counter++;
      }

      $self->say(
      channel => $message->{channel},
      body    => $purged_drama
      );
    }

    #host command
    if ($command eq 'host') {
      $self->say(
      channel => $message->{channel},
      body    => $nick . ', your host is ' . $who
      );
    }

    #say command
    if ($command =~ m/^say\s/) {
      #get what to say
      my ($say, $what_to_say) = split(/^say\s/, $command);


      #say it
      $self->say(
      channel => $message->{channel},
      body    => $what_to_say
      );
    } elsif ($command =~ m/^say\s*/) {
      if (!($command =~ m/^say_in_chan/)) {
        this_command_needs_args("say", 1, $message, $self);
      }
    }

    #say_in_chan
    if ($command =~ m/^say_in_chan\s.+\s.+/) {
      my ($say_in_chan, $rest) = split(/^say_in_chan\s/, $command);

      #get chan/say
      my $the_chan = substr($rest, 0, index($rest, ' '));
      my @get_to_say = split(/\s/, $rest);
      my $count = 0;
      my $to_say = '';
      foreach my $word (@get_to_say) {
        if ($count == 0) {
          if ($word eq $the_chan) {
            $count += 2;
          } else {
            $to_say = $to_say . ' ' . $word;
          }
        } else {
          $to_say = $to_say . ' ' . $word;
        }
      }

      $to_say = substr($to_say, 1);
      $self->say(
      channel => $the_chan,
      body    => $to_say
      );
    } elsif ($command =~ m/^say_in_chan/) {
      this_command_needs_args("say_in_chan", 2, $message, $self);
    }

    #act_in_chan
    if ($command =~ m/^act_in_chan\s.+\s.+/) {
      my ($act_in_chan, $rest) = split(/^act_in_chan\s/, $command);

      #get chan/say
      my $the_chan = substr($rest, 0, index($rest, ' '));
      my @get_to_act = split(/\s/, $rest);
      my $count = 0;
      my $to_act = '';
      foreach my $word (@get_to_act) {
        if ($count == 0) {
          if ($word eq $the_chan) {
            $count += 2;
          } else {
            $to_act = $to_act . ' ' . $word;
          }
        } else {
          $to_act = $to_act . ' ' . $word;
        }
      }

      $to_act = substr($to_act, 1);
      $self->emote(
      channel => $the_chan,
      body    => $to_act
      );
    } elsif ($command =~ m/^act_in_chan/) {
      this_command_needs_args("act_in_chan", 2, $message, $self);
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
      body    => ('My activation character is @ and I can do these commands: drama, github, help, say, say_in_chan (chan then message), act_in_chan (chan then message), kill, cookie, action, and host. I can also do part, join, and quit if the person is authenticated with me. To authenticate msg me @auth [the-password]. For channel ops you can do the leave command to get rid of me')
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
