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

  my $last_op = '';
  my $counter = 0;

  foreach my $index (0 .. scalar(@{$bot_vars->{ops}})) {
    if (@{$bot_vars->{ops}}[$index] eq $last_op) {
      delete @{$bot_vars->{ops}}[$index];
    }
    $last_op = @{$bot_vars->{ops}}[$index];
  }

  $bot->say(
  channel => $message->{channel},
  who     => $message->{who},
  body    => 'These are the people who are ops for me' . join(", ", @{$bot_vars->{ops}})
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
