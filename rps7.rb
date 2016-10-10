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
    @type =
    case string
    when "rock" then Rock.new
    when "paper" then Paper.new
    when "scissors" then Scissors.new
    when "lizard" then Lizard.new
    when "spock" then Spock.new
    end
  end
end

class Human < Player
  def set_name
    temp_name = ''
    loop do
      puts "What's your name?"
      temp_name = gets.chomp
      break unless temp_name.empty? || temp_name.match(/^\s*$/)
      puts "Sorry , must enter a value."
    end
    self.name = temp_name
  end

  def choose
    choice = ''
    loop do
      puts "Please choose #{RPSGame::TYPES.join(', ')}:"
      choice = gets.chomp.downcase
      break if RPSGame::TYPES.include? choice
      puts "Sorry, invalid choice."
    end
    self.type = string_to_type(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', "Soony", "Chappie", "Number 5"].sample
  end

  def choose(choice_arr)
    self.type = string_to_type(choice_arr.sample)
  end
end

class History
  attr_accessor :caches

  def initialize
    @caches = { win: [], lose: [], tie: [] }
  end

  def record(last_game, human, computer)
    caches[last_game] << [human.type.value, computer.type.value]
  end
end

class RPSGame
  TYPES = ['rock', 'paper', 'scissors', 'lizard', 'spock'].freeze

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

  def determine_winner
    if human.type.win?(computer.type)
      human.score.add_one
      @last_game = :lose
    elsif computer.type.win?(human.type)
      computer.score.add_one
      @last_game = :win
    else
      @last_game = :tie
    end
  end

  def display_winner
    puts "#{human.name} won!" if @last_game == :lose
    puts "#{computer.name} won!" if @last_game == :win
    puts "It's a tie." if @last_game == :tie
  end

  def display_score
    puts "#{human.name} score is #{human.score.value}."
    puts "#{computer.name} score is #{computer.score.value}"
  end

  def display_moves
    puts "#{human.name} chose #{human.type.value}."
    puts "#{computer.name} chose #{computer.type.value}"
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
    answer.casecmp('y').zero? ? true : false
  end

  def reset_score
    human.score.reset
    computer.score.reset
  end

  def full_score?
    human.score.value >= 5 || computer.score.value >= 5
  end

  def starting_position
    @bots = {
    'R2D2'=> { 'rock' => 5, 'paper' => 20, 'scissors' => 5,
               'lizard' => 5, 'spock' => 5 },
    'Hal'=> { 'rock' => 5, 'paper' => 5, 'scissors' => 5,
              'lizard' => 5, 'spock' => 10 },
    'Soony'=> { 'rock' => 0, 'paper' => 5, 'scissors' => 5,
                'lizard' => 5, 'spock' => 5 },
    'Chappie'=> { 'rock' => 5, 'paper' => 5, 'scissors' => 5,
                  'lizard' => 20, 'spock' => 5 },
    'Number 5'=> { 'rock' => 20, 'paper' => 5, 'scissors' => 20,
                   'lizard' => 5, 'spock' => 5 }
    }
  end

  def odd_generator
    arr = []
    starting_position
    types = @bots[computer.name]
    history.caches[:lose].each { |pair| types[pair[1]] -= 1 }
    types.each do |key, value|
      value = 1 if value <= 1
      value.times { arr << key }
    end
    arr
  end

  def display
    display_moves
    display_winner
    display_score
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose(odd_generator)
      determine_winner
      display
      history.record(@last_game, human, computer)
      next unless full_score?
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
