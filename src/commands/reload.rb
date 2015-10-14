# Gems
require 'cinch'

# Local
require_relative '../wrapper'
require_relative '../variables'

# The @reload command
class ReloadPlugin
  include Cinch::Plugin

  match(/reload\s.*/)
  def execute(m)
    synchronize(:bot) do
      s = m.message[8..-1]
      if Wrapper.op? m.user
        if Wrapper.plugin? s
          Wrapper.reload s
          m.reply "Reloaded #{s}"
        else
          m.reply "#{s} is not a plugin or the wrapper"
        end
      else
        m.reply 'This is an op-only command, you are not oped'
      end
    end
  end
end
