require 'cinch'
require_relative 'variables'

# Commands
require_relative 'commands/hello'

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

        c.plugins.plugins = [HelloPlugin]
        c.plugins.prefix = /^@/
      end
    end

    def run
      BOT.start
    end

    def restart
      BOT.stop
      BOT.start
    end
  end
end
