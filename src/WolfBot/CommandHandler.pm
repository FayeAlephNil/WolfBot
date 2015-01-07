use warnings;
use strict;
use diagnostics;

package WolfBot::CommandHandler;

sub new {
  my ($class, %args) = @_;
  print("New CommandHandler made\n");
  return bless { %args }, $class;
}

sub add_command {
  my ($self, $command) = @_;

  $self->{commands} //= [];
  push(@{$self->{commands}}, $command);
}

sub del_command {
  my ($self, $command) = @_;

  if (defined $self->{commands}) {
    @{$self->{commands}} = grep($_->{name} ne $command->{name}, @{$self->{commands}});
  }
}

sub add_commands {
  my ($self, @commands) = @_;

  foreach my $command (@commands) {
    $self->add_command($command);
  }
}

sub del_commands {
  my ($self, @commands) = @_;

  foreach my $command (@commands) {
    $self->del_command($command);
  }
}

sub run {
  my ($self, $bot, $bot_vars, $message) = @_;

  print("CommandHandler was run\n");
  foreach my $command (@{$self->{commands}}) {
    $command->run($bot, $bot_vars, $message);
  }
}
1;
