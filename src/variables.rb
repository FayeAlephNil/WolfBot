# Module for all variables that will be used
module Variables
  def self.putget(str)
    puts str
    gets.chomp
  end

  NICK = putget 'What is the nick?'
  USER = putget 'What is the username?'
  PASSWORD = putget 'What is the password?'
  AUTHPASSWORD = putget 'What is the authentication password?'
  OPS = []
  COMMANDS = {
    # Implemented

    'hello' => 'Will say "Hello, my name is Wolfbot"',
    'restart' => 'Restarts the bot, op-only (does not effect plugins)',
    'op' => 'Given a password will give op power to you',
    'commands' => 'Gets the list of commands, sent in a private message',

    # Non-implemented TODO
    'join' => 'This method tells the bot to join a channel',
    'part' => 'Will tell the bot to part from a channel',
    'help' => 'Hello, my name is WolfBot, and my activation character is @ ' \
              'This will give the help for a specific command given one. ' \
              'Use @commands to get the list of commands',
    'reload' => 'Reloads a plugin (plugin format is <CamelCommandName>Plugin)',
    'reloadall' => 'Reloads all plugins'
  }
end
