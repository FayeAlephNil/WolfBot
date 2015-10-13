require 'cinch'
require_relative '../variables'

# The @commands command
class CommandsPlugin
  include Cinch::Plugin

  match 'commands'
  def execute(m)
    m.user.send Variables::COMMANDS.keys.join ', '
  end
end
