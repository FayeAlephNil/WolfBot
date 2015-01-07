use warnings;
use strict;
use diagnostics;

package WolfBot::Commands::CommandOps;

sub new {
  my ($class, %args) = @_;
  return bless { %args }, $class;
}

sub run {
  my ($self, $bot, $bot_vars, $message) = @_;

  if ($message->{body} =~ m/^\@/) {
    my ($activation, $command) = split(/^@/, $message->{body});
    if ($command eq 'ops') {
      say_ops($bot, $bot_vars, $message);
    }
  }
}

sub say_ops {
  my ($bot, $bot_vars, $message) = @_;

  $bot->say(
  channel => $message->{channel},
  who     => $message->{who},
  body    => join(", ", @{$bot_vars->{ops}})
  );
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
1;
