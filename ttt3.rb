class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]].freeze

  def initialize
    @squares = {}
    reset
  end

  def [](key)
    @squares[key]
  end

  def []=(key, marker)
    @squares[key].marker = marker
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

  def count_unique_marker(squares)
    squares.map(&:marker).uniq.count
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

  def threat_imminent?(marker)
    !!find_at_risk_square(marker)
  end

  def find_at_risk_square(marker)
    WINNING_LINES.each do |line|
      squares_hash = @squares.select { |k, _| line.include?(k) }
      markers = squares_hash.values.collect(&:marker)
      if markers.count(marker) == 2 &&
         markers.count(Square::INITIAL_MARKER) == 1
        return squares_hash.select { |_, square| square.unmarked? }.keys.first
      end
    end
    false
  end

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
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

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end
end

class Square
  INITIAL_MARKER = ' '.freeze

  attr_accessor :marker

  def initialize
    @marker = INITIAL_MARKER
  end

  def to_s
    @marker
  end

  def unmarked?
    @marker == INITIAL_MARKER
  end

  def marked?
    !unmarked?
  end
end

class Player
  attr_reader :marker, :name
  attr_accessor :score

  def initialize
    @score = 0
  end
end

class Computer < Player
  def initialize(marker)
    @human_marker = marker
    @marker = set_marker
    @name = "Teminator"
    super()
  end

  def set_marker
    @human_marker == "X" ? "O" : "X"
  end
end

class Human < Player
  def initialize
    @marker = set_marker
    @name = set_name
    super()
  end

  def set_name
    temp_name = ''
    loop do
      puts "What's your name?"
      temp_name = gets.chomp
      break unless temp_name.strip.empty?
      puts "Invalid name."
    end
    temp_name
  end

  def set_marker
    marker = ''
    loop do
      puts "What marker do you want ? (X or O)"
      marker = gets.chomp
      break if %w(X O).include? marker
      puts "only X or O available."
    end
    marker
  end
end

class TTTGame
  FIRST_TO_MOVE = :human

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new(@human.marker)
    @turn = FIRST_TO_MOVE
  end

  def play
    display_welcome_message
    loop do
      game_loop
      break unless play_again?
      game_reset
    end
    display_goodbye_message
  end

  private

  def game_loop
    loop do
      display_board
      turn_loop
      determine_result
      clear_screen_and_display_board
      display_result
      display_score
      round_reset
      if full_score?
        announce_winner
        break
      end
    end
  end

  def turn_loop
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def announce_winner
    if human.score >= 3
      puts "#{human.name} won the game!"
    else
      puts "#{computer.name} won the game!"
    end
  end

  def full_score?
    human.score >= 3 || computer.score >= 3
  end

  def display_welcome_message
    puts "welcome to Tic Tac Toe."
    puts ""
  end

  def display_goodbye_message
    puts "thanks for playing Tic Tac Toe. bye"
  end

  def clear
    system "clear"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "#{human.name} is a #{human.marker}.\
 #{computer.name} is a #{computer.marker}"
    puts ""
    board.draw
    puts ""
  end

  def human_turn?
    @turn == :human
  end

  def display_score
    puts "#{human.name}:#{human.score}. #{computer.name}:#{computer.score}"
  end

  def current_player_moves
    if @turn == :human
      human_moves
      @turn = :computer
    elsif @turn == :computer
      computer_moves
      @turn = :human
    end
  end

  def joinor(array, delimiter = ", ", connector = "or ")
    array[-1] = array[-1].to_s.prepend(connector) if array.size > 1
    array.size == 2 ? array.join(" ") : array.join(delimiter)
  end

  def human_moves
    puts "Choose a square between (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include? square
      puts "Sorry, invalid numbers."
    end
    board[square] = human.marker
  end

  def find_moves
    if board.find_at_risk_square(computer.marker)
      board.find_at_risk_square(computer.marker)
    elsif board.find_at_risk_square(human.marker)
      board.find_at_risk_square(human.marker)
    end
  end

  def computer_moves
    if find_moves
      board[find_moves] = computer.marker
    elsif board[5].unmarked?
      board[5] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def determine_result
    case board.winning_marker
    when human.marker
      human.score += 1
    when computer.marker
      computer.score += 1
    end
  end

  def display_result
    case board.winning_marker
    when human.marker
      puts "#{human.name} won the round." unless full_score?
    when computer.marker
      puts "#{computer.name} won the round." unless full_score?
    else
      puts "It's a tie"
    end
  end

  def play_again?
    answer = ''
    loop do
      puts "would you like to play again? (y / n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "sorry, must be y or n."
    end
    answer == 'y'
  end

  def round_reset
    board.reset
    @turn = FIRST_TO_MOVE
  end

  def game_reset
    board.reset
    @turn = FIRST_TO_MOVE
    clear
    human.score = 0
    computer.score = 0
  end

  def display_play_again
    puts "Let's play again."
    puts ""
  end
end

game = TTTGame.new
game.play
