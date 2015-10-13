require 'cinch'
require_relative '../wrapper'
require_relative '../variables'

# The @restart command
class RestartPlugin
  include Cinch::Plugin

  match 'restart'
  def execute(m)
    synchronize(:bot) do
      if Variables::OPS.any? { |x| x == m.user }
        m.reply 'Restarting'
        Wrapper.restart
      else
        m.reply 'This is an op-only command, you are not oped'
      end
    end
  end
end
