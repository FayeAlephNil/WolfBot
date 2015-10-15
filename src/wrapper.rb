# Gems
require 'cinch'
require 'require_all'

# Commands
require_rel 'commands'

# Extras

require_relative 'variables'

# Wrapper for the bot
class Wrapper
  class << self
    attr_accessor :pluginnames

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
          ReloadAllPlugin,
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
        @pluginnames = BOT.plugins.map do |plugin|
          plugin.class.name.downcase.chomp 'plugin'
        end
      end

      str = s.downcase.chomp 'plugin'
      @pluginnames.any? { |name| name == str }
    end

    def reload(classname)
      s = DIR + "/commands/#{classname.downcase.chomp('plugin')}.rb"
      load s
    end

    def reloadall
      BOT.plugins.each { |plugin| reload plugin.class.name }
    end

    def op?(u)
      Variables::OPS.any? { |x| x == u }
    end
  end
  @pluginnames = {}
end
