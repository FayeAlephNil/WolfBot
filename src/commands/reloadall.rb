# Gems
require 'cinch'

# Local
require_relative '../wrapper'

# The @reloadall command
class ReloadallPlugin
  include Cinch::Plugin

  match 'reloadall'
  def execute(m)
    synchronize(:bot) do
      if Wrapper.op? m.user
        Wrapper.reloadall
        m.reply 'Reloaded all plugins'
      else
        m.reply 'This is an op-only command'
      end
    end
  end
end
