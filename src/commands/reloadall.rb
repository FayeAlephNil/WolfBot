# Gems
require 'cinch'

# Local
require_relative '../wrapper'

# The @reloadall command
class ReloadPlugin
  include Cinch::Plugin

  match 'reloadall'
  def execute(_m)
    synchronize(:bot) do
      Wrapper.reloadall
    end
  end
end
