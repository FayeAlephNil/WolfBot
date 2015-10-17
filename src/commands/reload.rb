# Gems
require 'cinch'

# Local
require_relative '../wrapper'
require_relative '../variables'

# The @reload command
class ReloadPlugin
  include Cinch::Plugin

  match(/reload\s(.+)/)
  def execute(m, name)
    synchronize(:bot) do
      if Wrapper.op? m.user
        if Wrapper.plugin? name
          Wrapper.reload name
          m.reply "Reloaded #{name}"
        else
          m.reply "#{name} is not a plugin or the wrapper"
        end
      else
        m.reply 'This is an op-only command'
      end
    end
  end
end
