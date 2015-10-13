require 'cinch'
require_relative 'variables'

# Commands
require_relative 'commands/hello'
require_relative 'commands/commands'
require_relative 'commands/op'
require_relative 'commands/restart'

# Wrapper for the bot
class Wrapper
  class << self
    BOT = Cinch::Bot.new do
      configure do |c|
        c.server = 'irc.esper.net'
        c.channels = ['#Strikingwolf']
        c.nick = Variables::NICK
        c.password = Variables::PASSWORD
        c.realname = 'WolfBot'
        c.user = Variables::USER

        c.plugins.plugins = [
          HelloPlugin,
          OpPlugin,
          CommandsPlugin,
          RestartPlugin
        ]
        c.plugins.prefix = /^@/
      end
    end

    def run
      BOT.start
    end

    def restart
      # DOESN'T WORK
      BOT.quit
      BOT.start
    end
  end
end
