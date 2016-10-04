require 'pry'
class Rock
  attr_accessor :value
  
  def initialize
    @value = 'rock'
  end
  
  def win?(other_type)
    other_type.value == 'scissors' ||
    other_type.value == 'lizard'
  end
end

class Paper
  attr_accessor :value

  def initialize
    @value = 'paper'
  end
  
  def win?(other_type)
    other_type.value == 'rock' ||
    other_type.value == 'spock'
  end
end

class Scissors
  attr_accessor :value

  def initialize
    @value = 'scissors'
  end
  
  def win?(other_type)
    other_type.value == 'paper' ||
    other_type.value == 'lizard'
  end
end

class Lizard
  attr_accessor :value

  def initialize
    @value = 'lizard'
  end
  
  def win?(other_type)
    other_type.value == 'spock' ||
    other_type.value == 'paper'
  end
end

class Spock
  attr_accessor :value

  def initialize
    @value = 'spock'
  end
  
  def win?(other_type)
    other_type.value == 'rock' ||
    other_type.value == 'scissors'
  end
end

class Score
  attr_accessor :value
  
  def initialize
    @value = 0
  end
  
  def add_one
    @value += 1
  end
  
  def reset
    @value = 0
  end
end

class Player
  attr_accessor :type, :name, :score

  def initialize
    set_name
    @score = Score.new
  end
  
  def string_to_type(string)
    case string
    when "rock"
      @type = Rock.new
    when "paper"
      @type = Paper.new
    when "scissors"
      @type = Scissors.new
    when "lizard"
      @type = Lizard.new
    when "spock"
      @type = Spock.new
    end
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry , must enter a value."
    end
    self.name = n
  end

  def choose
    choice = ''
    loop do
      puts "Please choose #{RPSGame::TYPES.join(", ")}:"
      choice = gets.chomp
      break if RPSGame::TYPES.include? choice
      puts "Sorry, invalid choice."
    end
    self.type = string_to_type(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', "Soony", "Chappie"].sample
  end
  
  def choose(history)
    history.worst_type
    
    if history.worst == nil
      worst = RPSGame::TYPES 
    else
      case history.worst[0]
      when :rock
        worst = RPSGame::TYPES_ROCK
      when :paper
        worst = RPSGame::TYPES_PAPER
      when :scissors
        worst = RPSGame::TYPES_SCISSORS
      when :lizard
        worst = RPSGame::TYPES_LIZARD
      when :spock
        worst = RPSGame::TYPES_SPOCK
      end
    end
    binding.pry
    self.type = string_to_type(worst.sample)
  end
end

class History
  attr_accessor :caches, :worst
  
  def initialize
    @caches = []
  end
  
  def record(last_game, human_type, computer_type)
    self.caches << [last_game, human_type, computer_type]
  end
  
  def worst_type
    frequency = { :rock => 0, :paper => 0, :scissors => 0, :lizard => 0, :spock => 0 }
    
    lose_history = self.caches.select { |pair| pair[0] == 'win' }
    
    lose_history.each do |pair|
      case pair[2]
      when 'rock' then frequency[:rock] += 1
      when 'paper' then frequency[:paper] += 1
      when 'scissors' then frequency[:scissors] += 1
      when 'lizard' then frequency[:lizard] += 1
      when 'spock' then frequency[:spock] += 1
      end
    end
    worst_dummy = frequency.max_by { |k, v| v }
    worst_dummy[1] == 0 ? @worst = nil : @worst = worst_dummy
  end
  
end

class RPSGame
  TYPES = ['rock', 'paper', 'scissors', 'lizard', 'spock'].freeze
  TYPES_ROCK  = ['rock', 'paper', 'paper', 'scissors', 'scissors', 'lizard', 'lizard', 'spock', 'spock'].freeze
  TYPES_PAPER = ['rock', 'rock', 'paper', 'scissors', 'scissors', 'lizard', 'lizard', 'spock', 'spock'].freeze
  TYPES_SCISSORS  = ['rock', 'rock', 'paper', 'paper', 'scissors', 'lizard', 'lizard', 'spock', 'spock'].freeze
  TYPES_LIZARD = ['rock', 'rock', 'paper', 'paper', 'scissors', 'scissors', 'lizard', 'spock', 'spock'].freeze
  TYPES_SPOCK = ['rock', 'rock', 'paper', 'paper', 'scissors', 'scissors', 'lizard', 'lizard', 'spock'].freeze

  attr_accessor :human, :computer, :history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @history = History.new
  end

  def display_welcome_message
    puts "Welcome to rock, paper, scissors."
  end

  def display_goodbye_message
    puts "Thanks for playing rock, paper, scissors."
  end

  def display_moves
    puts "#{human.name} chose #{human.type.value}."
    puts "#{computer.name} chose #{computer.type.value}"
  end

  def display_winner
    if human.type.win?(computer.type)
      puts "#{human.name} won!"
      human.score.add_one
      @last_game = 'win'
    elsif computer.type.win?(human.type)
      puts "#{computer.name} won!"
      computer.score.add_one
      @last_game = 'lost'
    else
      puts "It's a tie."
      @last_game = 'tie'
    end
    puts "#{human.name} score is #{human.score.value}"
    puts "#{computer.name} score is #{computer.score.value}"
  end

  def play_again?
    reset_score
    answer = ''
    loop do
      puts "Would you like to play again? (y or n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry , answer must be y or n."
    end
    return true if answer.casecmp('y').zero?
    false
  end
  
  def reset_score
    human.score.reset
    computer.score.reset
  end
  
  def full_score?
    human.score.value >= 5 || computer.score.value >= 5
  end
  
  def analyze_history
    history.record(@last_game, human.type.value, computer.type.value)
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose(@history)
      display_moves
      display_winner
      analyze_history
      next unless full_score?
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
