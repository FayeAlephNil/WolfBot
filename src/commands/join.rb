# Gems
require 'cinch'

# Local
require_relative '../variables'
require_relative '../wrapper'

# The @reload command
class JoinPlugin
  include Cinch::Plugin

  match(/join\s(.+)/, method: :join)
  match(/join\s(\S+)\s(.+)/, method: :join_with_key)
  def join(m, chan)
    join_with_key(m, chan, nil)
  end

  def join_with_key(m, chan, key)
    synchronize(:bot) do
      Wrapper.bot.join chan, key
      m.reply "Joined #{chan}"
    end
  end
end
