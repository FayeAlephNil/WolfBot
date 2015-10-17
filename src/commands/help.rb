# Gems
require 'cinch'

# Local
require_relative '../variables'

# The @reload command
class HelpPlugin
  include Cinch::Plugin

  match('help', method: :general_help)
  match(/help\s(.+)/, method: :help)
  def general_help(m)
    m.reply Variables::HELP
  end

  def help(m, command)
    if Variables::COMMANDS[command].nil?
      m.reply "#{command} is not a command"
    else
      m.reply "#{command}: #{Variables::COMMANDS[command]}"
    end
  end
end
