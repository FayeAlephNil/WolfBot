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

    # Non-implemented TODO
    'join' => 'This method tells the bot to join a channel',
    'part' => 'Will tell the bot to part from a channel',
    'ops' => 'Given a password will give op power to you',
    'help' => 'Hello, my name is WolfBot, and my activation character is @ ' \
              'This will give the help for a specific command given one. ' \
              'Use @commands to get the list of commands',
    'commands' => 'Gets the list of commands'
  }
end
