require 'cinch'
require_relative '../variables'

# The @hello command
class HelloPlugin
  include Cinch::Plugin

  match 'hello'
  def execute(m)
    m.reply 'Hello, ' + m.user.nick + ', my name is ' + Variables::NICK + \
      ' or ' + Variables::USER + ', a WolfBot bot'
  end
end
