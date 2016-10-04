class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock'].freeze

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == "scissors"
  end

  def rock?
    @value == "rock"
  end

  def paper?
    @value == "paper"
  end
  
  def lizard?
    @value == "lizard"
  end
  
  def spock?
    @value == "spock"
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (rock? && other_move.lizard?) ||
      (paper? && other_move.rock?) ||
      (paper? && other_move.spock?) ||
      (scissors? && other_move.paper?) ||
      (scissors? && other_move.lizard?) ||
      (lizard? && other_move.spock?) ||
      (lizard? && other_move.paper?) ||
      (spock? && other_move.rock?) ||
      (spock? && other_move.scissors?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (rock? && other_move.spock?) ||
      (paper? && other_move.scissors?) ||
      (paper? && other_move.lizard?) ||
      (scissors? && other_move.rock?) ||
      (scissors? && other_move.spock?) ||
      (lizard? && other_move.rock?) ||
      (lizard? && other_move.scissors?) ||
      (spock? && other_move.lizard?) ||
      (spock? && other_move.paper?)
  end

  def to_s
    @value
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
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = Score.new
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
      puts "Please choose #{Move::VALUES.join(", ")}:"
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', "Soony", "Chappie"].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to rock, paper, scissors."
  end

  def display_goodbye_message
    puts "Thanks for playing rock, paper, scissors."
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
      human.score.add_one
    elsif human.move < computer.move
      puts "#{computer.name} won!"
      computer.score.add_one
    else
      puts "It's a tie."
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
    human.score.value >= 3 || computer.score.value >= 3
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      next unless full_score?
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
