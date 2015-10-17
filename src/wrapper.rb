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
    attr_reader :bot

    def run
      @bot.start
    end

    def plugin?(s)
      if @pluginnames == {}
        @bot.plugins.each do |plugin|
          @pluginnames[plugin.class.name.downcase.chomp 'plugin'] = plugin
        end
      end

      str = s.downcase.chomp 'plugin'
      @pluginnames.keys.any? { |name| name == str }
    end

    def reload(classname)
      load Variables::DIR + "/commands/#{classname.downcase.chomp('plugin')}.rb"
    end

    def reloadall
      @bot.plugins.each { |plugin| reload plugin.class.name }
    end

    def op?(u)
      Variables::OPS.any? { |x| x == u }
    end
  end

  @pluginnames = {}
  @bot = Cinch::Bot.new do
    configure do |c|
      c.server = 'irc.esper.net'
      c.channels = ['#Testing']
      c.nick = Variables::NICK
      c.password = Variables::PASSWORD
      c.realname = 'WolfBot'
      c.user = Variables::USER

      c.plugins.plugins = [
        HelloPlugin,
        OpPlugin,
        CommandsPlugin,
        ReloadPlugin,
        ReloadallPlugin,
        SrcPlugin,
        JoinPlugin,
        PartPlugin,
        HelpPlugin
      ]

      c.plugins.prefix = /^@/
    end
  end
end
