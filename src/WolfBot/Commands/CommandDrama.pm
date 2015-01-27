use warnings;
use strict;
use diagnostics;

package WolfBot::Commands::CommandDrama;
use LWP::Simple;

sub new {
  my ($class, %args) = @_;
  return bless { %args }, $class;
}

sub run {
  my ($self, $bot, $bot_vars, $message) = @_;

  if ($message->{body} =~ m/^\@/) {
    my ($activation, $command) = split(/^@/, $message->{body});
    if ($command eq 'drama') {
      $bot->say(
      channel => $message->{channel},
      body    => get_drama(),
      who     => $message->{who}
      );
    }
  }

}

sub get_drama {
  my $drama_url = "http://asie.pl/drama.php?2&plain";
  my $content = get($drama_url);
  my $drama = substr($content, 0, index($content, '<'));

  if ($drama eq '402 Payment Required') {
    my $drama_url = "http://bigxplosion.tk/drama.php?plain";
    my $content = get($drama_url);
    my $drama = substr($content, 0, index($content, '<'));
  }

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
1;
