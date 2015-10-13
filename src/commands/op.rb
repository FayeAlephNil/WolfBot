require 'cinch'
require_relative '../variables'

# The @op command
class OpPlugin
  include Cinch::Plugin

  match(/op.*/)
  def execute(m)
    synchronize(:ops) do
      pass = m.message[4..-1]
      if pass == Variables::AUTHPASSWORD
        Variables::OPS.push m.user
        m.reply 'You have been oped'
      else
        m.reply 'That is the wrong password'
      end
    end
  end
end
