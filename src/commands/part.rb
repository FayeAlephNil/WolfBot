# Gems
require 'cinch'

# Local
require_relative '../variables'
require_relative '../wrapper'

# The @reload command
class PartPlugin
  include Cinch::Plugin

  match('part', method: :part)
  match(/part\s(.+)/, method: :part_with_name)
  def part(m)
    if m.channel.nil?
      m.reply 'This is not a channel, specify the channel name to part from'
    else
      part_with_name(m, m.channel.name)
    end
  end

  def part_with_name(m, chan)
    synchronize(:bot) do
      Wrapper.bot.part chan
      m.reply "Parted from #{chan}"
    end
  end
end
