require 'cinch'
require_relative '../variables'

# The @op command
class OpPlugin
  include Cinch::Plugin

  match(/op\s(.+)/)
  def execute(m, pass)
    synchronize(:ops) do
      if pass == Variables::AUTHPASSWORD
        Variables::OPS.push m.user
        m.reply 'You have been oped'
      else
        m.reply 'That is the wrong password'
      end
    end
  end
end
