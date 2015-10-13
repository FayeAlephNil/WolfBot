require 'cinch'

# The @src command
class SrcPlugin
  include Cinch::Plugin

  match 'src'
  def execute(m)
    m.reply 'I am a WolfBot, I was created by Strikingwolf. You can see my ' + \
      'brain over here (https://github.com/Strikingwolf/WolfBot)'
  end
end
