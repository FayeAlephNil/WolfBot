require 'cinch'
require_relative 'variables'

# Commands
require 'require_all'
require_rel 'commands'

# Wrapper for the bot
class Wrapper
  class << self
    @@pluginhash = {}

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
          ReloadPlugin,
          SrcPlugin
        ]

        c.plugins.prefix = /^@/
      end
    end

    def run
      BOT.start
    end

    def get_plugin(s)
      if @@pluginhash == {}
	    BOT.plugins.each do |plugin|
	      @@pluginhash[plugin.class.name] = plugin
	    end
	  end
	  @@pluginhash[s]
    end

    def reload(c)
	  BOT.plugins.unregister_plugin c

	  s = c.class.name
	  load "commands/#{s.chomp('Plugin').downcase}.rb"
	  BOT.plugins.register_plugin (c.class)
	end

    def reloadall
      BOT.plugins.each method(:reload)
    end

    def op?(u)
      Variables::OPS.any? { |x| x == u }
    end
  end
end
