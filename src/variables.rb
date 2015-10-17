# Module for all variables that will be used
module Variables
  def self.putget(str)
    puts str
    gets.chomp
  end

  DIR = File.expand_path File.dirname(__FILE__)
  NICK = putget 'What is the nick?'
  USER = putget 'What is the username?'
  PASSWORD = putget 'What is the password?'
  AUTHPASSWORD = putget 'What is the authentication password?'
  OPS = []
  HELP = 'Hello, my name is WolfBot, and my activation character is @ ' \
            'This will give the help for a specific command given one. ' \
            'Use @commands to get the list of commands'
  COMMANDS = {
    # Implemented

    'hello' => 'Will say greet the person executing the command',
    'op' => 'Given a password will give op power to you',
    'commands' => 'Gets the list of commands, sent in a private message',
    'src' => 'Gives what I am, who I was created by, and where my brain is',
    'reload' => 'Reloads a plugin (plugin format is <commandname>, use' \
                ' "@reload wrapper" to reload the wrapper) OP-only',
    'reloadall' => 'Reloads all plugins and the wrapper OP-only',
    'join' => 'This method tells the bot to join a channel',
    'part' => 'Will tell the bot to part from a channel',
    'help' => 'Gives the general help information for this bot, given a' \
              ' specific command will give the help info for that command'

    # Non-implemented TODO
  }
end
