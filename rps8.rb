require 'pry'
class Score
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def full?
    @value >= 5
  end

  def reset
    self.value = 0
  end
end

class Rock
  attr_accessor :value

  def initialize
    @value = "rock"
  end

  def win_over(other_type)
    (other_type.instance_of? Scissors) || (other_type.instance_of? Lizard)
  end

  def lose_to(other_type)
    (other_type.instance_of? Paper) || (other_type.instance_of? Spock)
  end

  def to_s
    @value
  end
end

class Paper
  attr_accessor :value

  def initialize
    @value = "paper"
  end

  def win_over(other_type)
    (other_type.instance_of? Rock) || (other_type.instance_of? Spock)
  end

  def lose_to(other_type)
    (other_type.instance_of? Scissors) || (other_type.instance_of? Lizard)
  end

  def to_s
    @value
  end
end

class Scissors
  attr_accessor :value

  def initialize
    @value = "scissors"
  end

  def win_over(other_type)
    (other_type.instance_of? Paper) || (other_type.instance_of? Lizard)
  end

  def lose_to(other_type)
    (other_type.instance_of? Rock) || (other_type.instance_of? Spock)
  end

  def to_s
    @value
  end
end

class Lizard
  attr_accessor :value

  def initialize
    @value = "lizard"
  end

  def win_over(other_type)
    (other_type.instance_of? Paper) || (other_type.instance_of? Spock)
  end

  def lose_to(other_type)
    (other_type.instance_of? Rock) || (other_type.instance_of? Scissors)
  end

  def to_s
    @value
  end
end

class Spock
  attr_accessor :value

  def initialize
    @value = "spock"
  end

  def win_over(other_type)
    (other_type.instance_of? Rock) || (other_type.instance_of? Scissors)
    false
  end

  def lose_to(other_type)
    (other_type.instance_of? Paper) || (other_type.instance_of? Lizard)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = Score.new(0)
  end

  def string_to_obj(string)
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
  def choose
    choice = ''
    loop do
      puts "Please choose #{RPSGame::VALUES.join(', ')}:"
      choice = gets.chomp
      break if RPSGame::VALUES.include?(choice)
      puts "Invalid choice."
    end
    self.move = string_to_obj(choice)
  end

  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Name can't be empty."
    end
    self.name = n
  end
end

class Computer < Player
  attr_accessor :history, :weight

  def initialize(history)
    @history = history
    super()
  end

  def initial_weight
    case name
    when "R2D2" then @weight = { "rock" => 10, "paper" => 3,
                                 "scissors" => 3, "lizard" => 3, "spock" => 3 }
    when "Hal" then @weight = { "rock" => 3, "paper" => 10,
                                "scissors" => 3, "lizard" => 3, "spock" => 3 }
    when "Chappie" then @weight = { "rock" => 3, "paper" => 3, "scissors" => 10,
                                    "lizard" => 3, "spock" => 3 }
    when "Sonny" then @weight = { "rock" => 3, "paper" => 3, "scissors" => 3,
                                  "lizard" => 0, "spock" => 3 }
    when "Number 5" then @weight = { "rock" => 3, "paper" => 3, "scissors" => 3,
                                     "lizard" => 3, "spock" => 0 }
    end
  end

  def reassign_weight
    initial_weight
    history.lost.each do |type, percent|
      unless weight[type].zero?
        weight[type] -= 2 if percent >= 60
      end
    end
  end

  def build_population
    population = []
    weight.each do |key, weight|
      weight.times { population << key }
    end
    population
  end

  def choose
    reassign_weight
    move = build_population.sample
    self.move = string_to_obj(move)
  end

  def set_name
    self.name = ["R2D2", "Hal", "Chappie", "Sonny", "Number 5"].sample
  end
end

class History
  attr_accessor :list, :lost

  def initialize
    @list = { win: [], lose: [], tie: [] }
    @lost = { "rock" => 0, "paper" => 0, "scissors" => 0, "lizard" => 0,
              "spock" => 0 }
  end

  def analyze
    total_games = list[:win].count + list[:lose].count + list[:tie].count
    lost.each do |k, _|
      lost_games = list[:win].select { |ary| ary[1].value == k }.count
      lost[k] = (lost_games * 100 / total_games) unless total_games.zero?
    end
    lost
  end
end

class RPSGame
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock'].freeze

  attr_accessor :human, :computer, :history

  def initialize
    @human = Human.new
    @history = History.new
    @computer = Computer.new(@history)
  end

  def display_welcome_message
    puts "Welcome to rock, paper and scissors."
  end

  def display_goodbye_message
    puts "Thanks for playing rock, paper and scissors."
  end

  def display_moves
    puts "#{human.name} chose #{human.move}. #{computer.name} chose \
#{computer.move}."
  end

  def display_score
    puts "#{human.name} score is #{human.score.value}. #{computer.name} \
score is #{computer.score.value}"
  end

  def determine_round_winner
    if human.move.win_over(computer.move)
      human.score.value += 1
      history.list[:win] << [human.move, computer.move]
    elsif human.move.lose_to(computer.move)
      computer.score.value += 1
      history.list[:lose] << [human.move, computer.move]
    else
      puts "It's a tie"
      history.list[:tie] << [human.move, computer.move]
    end
  end

  def display_winner
    if human.score.full?
      puts "#{human.name} won the game."
    elsif computer.score.full?
      puts "#{computer.name} won the game."
    end
  end

  def play_again?
    answer = ''
    loop do
      puts "Would you like to play again ? (y or n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer
      puts "sorry, must be y or n."
    end
    return false if answer.casecmp('n').zero?
    return true if answer.casecmp('y').zero?
  end

  def game_reset
    display_winner
    human.score.reset
    computer.score.reset
  end

  def play
    display_welcome_message
    loop do
      loop do
        human.choose
        computer.choose
        display_moves
        determine_round_winner
        display_score
        history.analyze
        break if human.score.full? || computer.score.full?
      end
      game_reset
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
