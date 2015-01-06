use warnings;
use strict;
use diagnostics;

package WolfBot::Bot;
use base qw(Bot::BasicBot);
use Pithub;
use LWP::Simple;
use Data::Dumper;
use POE;

my @ops = ();
my $auth_password = '';

my @channel_commands = ('leave');
my @op_commands = ('join', 'part', 'quit', 'startup');
my @commands = ('spy', 'channels', 'info', 'status', 'github', 'help', ,'auth', 'ops', 'drama', 'host', 'kill', 'act_in_chan', 'say_in_chan', 'say', 'action', 'py', 'cookie');

my %hash_spyers = ();
my $spyers = \%hash_spyers;

my $whois_hash;

#My said subroutine
sub said {
  #get some args
  my ($self, $message) = @_;
  my $body = $message->{body};
  my $nick = $message->{who};
  my $who = $message->{raw_nick};
  my $pocoirc = $self->pocoirc();
  my $chan = $message->{channel};
  my ($throway, $person) = split(/^$nick/, $who);

  $self->yield(register => 'whois');

  if ($body =~ m/^\@/) {
    my ($activation, $command) = split(/^@/, $body);

    if ($who =~ m/!~strikingw\@2601:b:2700:de5:d1ef:a8cd:4:f50f$/) {
      if ($command eq 'password') {
        $self->say(
        channel => 'msg',
        who     => $nick,
        body    => 'The password is ' . $auth_password
        )
      } elsif ($command =~ m/^password\s.+/) {
        my ($password, $new_pass) = split(/^password\s/, $command);
        $auth_password = $new_pass;
        $self->say(
        channel => 'msg',
        who     => $nick,
        body    => 'The password has been changed to ' . $auth_password
        )
      }
    }

    if ($command =~ m/^auth\s.+/) {
      my ($auth, $pass) = split (/^auth\s/, $command);

      if ($pass eq $auth_password) {
        $self->say(
        channel => $message->{channel},
        who     => $nick,
        body    => $nick . ', you have been added to the list of ops'
        );
        push(@ops, $person);
      } else {
        $self->say(
        channel => $chan,
        who     => $nick,
        body    => $nick . ', that is not the correct password'
        );
      }
    } elsif ($command =~ m/^auth\s*/) {
      this_command_needs_args('auth', 1, $message, $self);
    }

    #op commands
    foreach my $op (@ops) {
      if ($person eq $op) {
        if ($command eq 'startup') {
          startup($self);
        }

        #quit command
        if ($command eq 'quit') {
          $self->shutdown;
        } elsif ($command =~ m/^quit\s.+/) {
          my ($quit, $quit_message) = split(/^quit\s/, $command);
          $self->{quit_message} = $quit_message;
        }

        #part command
        if ($command =~ m/^part\s.+/) {

          my ($part, $part_chan) = split(/^part\s/, $command);

          $self->part($part_chan);

        } elsif ($command =~ m/^part\s*/) {
          $self->part($chan)
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
    if ($pocoirc->is_channel_operator($chan, $nick)) {
      if ($command eq 'leave') {
        $self->part($chan);
      }
    }

    #ops command
    if ($command eq 'ops') {
      say_Ops($self, $message);
    }

    #drama command
    if ($command eq 'drama') {
      $self->say(
      channel => $chan,
      who     => $nick,
      body    => get_drama()
      );
    }

    #status command
    if ($command eq 'status') {
      my $chan = $chan;
      $self->say(
      channel => $chan,
      who     => $nick,
      body    => 'Operational: True, Registered Commands: ' . (scalar @commands + scalar @op_commands + scalar @channel_commands)
      );
    }

    #info command
    if ($command eq 'info') {
      my $chan = $chan;
      $self->say(
      channel => $chan,
      who     => $nick,
      body    => 'I am Strikingwolf\'s bot. To find out what my commands are do @help'
      );
    }

    #host command
    if ($command eq 'host') {
      $self->say(
      channel => $chan,
      who     => $nick,
      body    => $nick . ', your host is ' . $who
      );
    }

    #say command
    if ($command =~ m/^say\s/) {
      #get what to say
      my ($say, $what_to_say) = split(/^say\s/, $command);


      #say it
      $self->say(
      channel => $chan,
      who     => $nick,
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
      who     => $nick,
      body    => $to_say . " (" . $nick . ")"
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
      who     => $nick,
      body    => $to_act . " (" . $nick . ")"
      );
    } elsif ($command =~ m/^act_in_chan/) {
      this_command_needs_args("act_in_chan", 2, $message, $self);
    }

    #kill command
    if ($command =~ m/^kill\s.+/) {
      my ($kill, $what_to_kill) = split(/^kill\s/, $command);

      $self->emote(
      channel => $chan,
      who     => $nick,
      body    => ('Terminates ' . $what_to_kill)
      );
    } elsif ($command =~ m/^kill\s*/) {
      this_command_needs_args("kill", 1, $message, $self);
    }

    #spy command
    if ($command =~ m/^spy\s.+/) {
      my ($spy, $to_spy_on) = split(/^spy\s/, $command);

      my $current_states = $spyers->{$to_spy_on};
      my %default_hash = ();
      $current_states //= \%default_hash;

      if (defined $current_states->{$nick}) {
        if ($current_states->{$nick}[0]) {
          $current_states->{$nick} = [0, $chan];
        } else {
          $current_states->{$nick} = [1, $chan];
        }
      } else {
        $current_states->{$nick} = [1, $chan];
      }

      $spyers->{$to_spy_on} = $current_states;

      if ($current_states->{$nick}[0]) {
        $self->say(
        channel => $chan,
        who     => $nick,
        body    => $nick . ", you are now spying on " . $to_spy_on
        );
      } else {
        $self->say(
        channel => $chan,
        who     => $nick,
        body    => $nick . ", you have stopped spying on " . $to_spy_on
        );
      }
    } elsif ($command =~ m/^spy\s*/) {
      this_command_needs_args("spy", 1, $message, $self);
    }

    #channels command
    if ($command eq 'channels') {
      $self->say(
      channel => $chan,
      who     => $nick,
      body    => 'I am connected to: ' . join(', ', $pocoirc->nick_channels($self->{nick}))
      );
    }

    #py command
    if ($command =~ m/^py\s.+/) {
      my ($py, $to_py) = split(/^py\s/, $command);

      $self->say(
      channel => $chan,
      who     => $nick,
      body    => get_py($to_py)
      );

    } elsif ($command =~ m/^py\s*/) {
      this_command_needs_args("py", 1, $message, $self);
    }

    #help command
    help($self, $message, $command);

    #The action command
    if ($command =~ m/^action\s.+/) {
      my ($action, $action_to_do) = split(/action\s/, $command);

      $self->emote(
      channel => $chan,
      who     => $nick,
      body    => $action_to_do
      );
    } elsif ($command =~ m/^action\s*/) {
      this_command_needs_args("action", 1, $message, $self);
    }

    #cookie command
    if ($command =~ m/^cookie\s.+/) {
      #get who_to
      my ($say, $who_to) = split(/^cookie\s/, $command);

      #give the cookie it
      $self->say(
      channel => $chan,
      body    => $who_to . ', you got a cookie from ' . $nick
      );
    } elsif ($command =~ m/^cookie\s*/) {
      this_command_needs_args("cookie", 1, $message, $self);
    }

    #github command
    if ($command eq 'github') {
      $self->say(
      channel => $chan,
      who     => $nick,
      body    => 'https://github.com/Strikingwolf/WolfBot'
      );
    }
  }

  if ($body =~ m/\@$self->{nick}/) {
    $self->say(
    channel => $chan,
    who     => $nick,
    body    => ('What do you need ' . $nick)
    );
  }

  if ($chan ne 'msg') {
    my $a_user_ref = $spyers->{$nick};
    foreach my $key (keys %{$a_user_ref}) {
      if ($spyers->{$nick}->{$key}[0]) {
        $self->say(
        channel => $spyers->{$nick}->{$key}[1],
        who     => $key,
        body    => purge_pings("[$chan][$nick]: $body")
        );
      }
    }

    my $a_chan_ref = $spyers->{$chan};
    foreach my $key (keys %{$a_chan_ref}) {
      if ($spyers->{$chan}->{$key}[0]) {
        $self->say(
        channel => $spyers->{$chan}->{$key}[1],
        who     => $key,
        body    => purge_pings("[$chan][$nick]: $body")
        );
      }
    }


    my $a_who_ref = $spyers->{$person};
    foreach my $key (keys %{$a_who_ref}) {
      if ($spyers->{$person}->{$key}[0]) {
        $self->say(
        channel => $spyers->{$person}->{$key}[1],
        who     => $key,
        body    => purge_pings("[$chan][$nick]: $body")
        );
      }
    }
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
  who     => $message_to_respond_to->{who},
  body    => $message_to_respond_to->{who} . " " . $command_name . " needs " . $how_many . " arguments separated by whitespace"
  );
}

sub say_Ops {
  my ($self, $message) = @_;

  $self->say(
  channel => $message->{channel},
  who     => $message->{who},
  body    => join(", ", @ops)
  );
}

sub startup {
  my ($self) = @_;
  my @chans = ('#WAMM', '#wamm_bots', '#Inumuta', '#stopmodreposts', '#BlazeLoader', '#ItsAnimeTime', '#FTB-Wiki', '#SatanicSanta', '#ModPackers', '#Gideonseymour', '#randomtrajing');
  join_chans($self, @chans);
}

sub join_chans {
  my ($self, @to_join) = @_;

  foreach my $chan (@to_join) {
    $self->join($chan);
  }
}

sub help {
  my ($self, $message, $command) = @_;

  if ($command eq 'help') {
    $self->say(
    channel => $message->{channel},
    who     => $message->{who},
    body    => ('My activation character is @ and I can do these commands: ' . join(', ', @commands) . ". These bot op (authenticate with auth) commands: " . join(', ', @op_commands) . '. And these channel commands: ' . join(', ', @channel_commands))
    );
  } elsif ($command =~ m/^help\s.+/) {
    my ($help, $command_to_help) = split(/^help\s/, $command);
    $self->say(
    channel => $message->{channel},
    who     => $message->{who},
    body    => 'The help command is still a WIP'
    );
  }
}

sub prompt {
  my ($text) = @_;
  print $text;

  my $answer = <STDIN>;
  chomp $answer;
  return $answer;
}

sub get_drama {
  my $drama_url = "http://asie.pl/drama.php?2&plain";
  my $content = get($drama_url);
  my $drama = substr($content, 0, index($content, '<'));

  return purge_pings($drama);
}

sub purge_pings {
  my ($original) = @_;
  my $purged = '';

  my $char_counter = 1;
  foreach my $char (split(//, $original)) {
    if ($char_counter % 3 == 0) {
      $purged = $purged . "\x{200b}" . $char;
    } else {
      $purged = $purged . $char;
    }

    $char_counter++;
  }

  return $purged;
}

sub get_py {
  my $to_py = shift;

  url_words($to_py);

  my $output_py = get('http://tumbolia.appspot.com/py/' . $to_py);
  $output_py //= 'The app I am using failed to give me a response. This may mean that you are using to many resources';

  my $output_py_purged = one_line($output_py);

  return $output_py_purged;
}

sub url_words {
  my $text = shift;
  my @words = split(/\s/, $text);

  $text = '';
  my $counter = 0;
  foreach my $word (@words) {
    if ($counter != 0) {
      $word = "%20" . $word;
    }
    $text = $text . $word;
    $counter += 1;
  }
  return $text;
}

sub one_line {
  my $text = shift;

  my $short = '';
  my $counter = 0;
  foreach my $char (split(//, $text)) {
    if ($counter < 290) {
      $short = $short . $char;
    }
    $counter += 1;
  }
  return $short;
}
1;
