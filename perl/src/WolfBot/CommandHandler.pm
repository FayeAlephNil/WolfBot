use warnings;
use strict;
use diagnostics;

package WolfBot::CommandHandler;

sub new {
  my ($class, %args) = @_;
  return bless { %args }, $class;
}

sub add_command {
  my ($self, $command) = @_;

  $self->{commands} //= [];
  push(@{$self->{commands}}, $command);
}

sub del_command {
  my ($self, $command) = @_;

  del_command_name($command->{name});
}

sub del_command_name {
  my ($self, $name) = @_;
  if (defined $self->{commands}) {
    @{$self->{commands}} = grep($_->{name} ne $name, @{$self->{commands}});
  }
}

sub get_commands_with {
  my ($self, $name) = @_;
  return grep($_->{name} eq $name, @{$self->{commands}});
}

sub get_command {
  my ($self, $command) = @_;
  return get_commands_with($command->{name});
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

  foreach my $command (@{$self->{commands}}) {
    $command->run($bot, $bot_vars, $message);
  }
}
1;
