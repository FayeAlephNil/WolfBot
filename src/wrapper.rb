require 'cinch'
require_relative 'variables'

# Commands
require 'require_all'
require_rel 'commands'

# Wrapper for the bot
class Wrapper
  class << self
    @pluginnames = {}

    DIR = File.expand_path File.dirname(__FILE__)

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

    def plugin?(s)
      if @pluginnames == {}
        @pluginnnames = BOT.plugins.map do |plugin|
          plugin.class.name
        end
      end
      @pluginnnames.any? { |name| name == s }
    end

    def reload(classname)
      s = DIR + "/commands/#{classname.downcase.chomp('plugin')}.rb"
      p s
      load s
    end

    def reloadall
      BOT.plugins.each { |plugin| reload plugin.class.name }
      reloadwrapper
    end

    def reload_wrapper
      load DIR + '/wrapper'
      load DIR + '/variables'
    end

    def op?(u)
      Variables::OPS.any? { |x| x == u }
    end
  end
end
