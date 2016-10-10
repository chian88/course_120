require 'pry'
class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " ".freeze

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    @marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker
  attr_accessor :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end
end

class TTTGame
  HUMAN_MARKER = "X".freeze
  COMPUTER_MARKER = "O".freeze
  FIRST_TO_MOVE = HUMAN_MARKER
  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end
  
  def full_score?
    if human.score >= 3
      puts "You won the game."
      true
    elsif computer.score >= 3
      puts "Computer won the game."
      true
    end
    false
  end

  def play
    display_welcome_message
    clear
    loop do
      display_board
      loop do
        loop do
          current_player_moves
          break if board.someone_won? || board.full?
          clear_screen_and_display_board if human_turn?
        end
        binding.pry
        reset
        display_result
        break if full_score?
      end
      break unless play_again?
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  def clear
    system "clear"
  end

  def display_welcome_message
    puts "welcome to tic tac toe."
    puts ""
  end

  def display_goodbye_message
    puts "thanks for playing tic tac toe. bye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You are a #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end
  
  def joinor(array, delimiter = ", ", connector = "or ")
    if array.size > 2
      array[-1] = array.last.to_s.prepend(connector)
      array.join(delimiter)
    else
      array.join(connector)
    end
  end

  def human_moves
    puts "Choose a square #{ joinor(board.unmarked_keys, ", ", "and ") }:"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      human.score += 1
      puts "You won this round.Human #{human.score}.Computer #{computer.score}."
    when computer.marker
      computer.score += 1
      puts "Computer won this round.Human #{human.score}.Computer #{computer.score}."
    else
      nil
    end
  end

  def play_again?
    answer = ''
    loop do
      puts "Would you like to play again? (y / n )"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "sorry must y or n."
    end
    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def display_play_again_message
    puts "Let's play again."
    puts ""
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end
end

game = TTTGame.new
game.play
