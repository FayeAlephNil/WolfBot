# Gems
require 'cinch'

# Local
require_relative '../wrapper'
require_relative '../variables'

# The @reload command
class ReloadPlugin
  include Cinch::Plugin

  match(/reload.*/)
  def execute(m)
    synchronize(:bot) do
      s = m.message[8..-1]
      if Wrapper.op? m.user
        plugin = Wrapper.get_plugin(s)
        if !plugin.nil?
          Wrapper.reload
          m.reply "Reloaded #{s}"
        else
          m.reply "#{s} is not a plugin"
        end
      else
        m.reply 'This is an op-only command, you are not oped'
      end
    end
  end
end
