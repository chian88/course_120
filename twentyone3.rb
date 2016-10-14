require 'pry'
class Hand
  attr_reader :value

  def initialize
    @value = []
  end

  def adjust_for_aces(total)
    deduction = 0
    num_of_aces = value.select(&:ace?).count
    num_of_aces.times do
      break if total <= 21
      deduction += 10
      total -= 10
    end
    deduction
  end

  def total
    sum = 0
    value.each do |card|
      card_value = card.value.last
      sum += if card_value == "A"
               11
             elsif card_value.to_i.zero?
               10
             else
               card_value.to_i
             end
    end
    sum -= adjust_for_aces(sum)
  end

  def get_card(card)
    @value << card
  end
end

class Participant
  attr_accessor :hand
  attr_reader :name

  def initialize(name)
    @hand = Hand.new
    @name = name
  end

  def joiner(str_arr)
    str_arr[-1] = str_arr[-1].prepend("and ")
    str_arr
  end

  def show_hand(number = hand.value.size)
    on_hand = joiner(hand.value.collect(&:formatted_value))
    covered_hand = on_hand.slice(0, number)
    covered_hand.size > 2 ? covered_hand.join(", ") : covered_hand.join(" ")
  end

  def busted?
    hand.total > 21
  end

  def less_than_17?
    hand.total < 17
  end
end

class Deck
  attr_accessor :bundle

  def initialize
    @bundle = build_deck
  end

  def build_deck
    bundle = []
    ['S', 'D', 'H', 'C'].each do |suit|
      (2..10).each { |pip| bundle << Card.new(suit, pip) }
      ['K', 'Q', 'J', 'A'].each { |pip| bundle << Card.new(suit, pip) }
    end
    bundle
  end

  def deal
    chosen_card = bundle.sample
    bundle.delete(chosen_card)
    chosen_card
  end
end

class Card
  SUIT = { "H" => "Heart", "D" => "Diamond", "C" => "Club",
           "S" => "Spades" }.freeze
  PIP = { "A" => "Ace", 2 => "Two", 3 => "Three", 4 => "Four", 5 => "Five",
          6 => "Six", 7 => "Seven", 8 => "Eight", 9 => "Nine", 10 => "Ten",
          "K" => "King", "Q" => "Queen", "J" => "Jack" }.freeze

  attr_reader :value

  def initialize(suits, pips)
    @value = [suits, pips]
  end

  def ace?
    value[1] == "A"
  end

  def formatted_value
    [PIP[value[1]], SUIT[value[0]]].join(" of ")
  end
end

class Game
  attr_accessor :player, :dealer, :deck

  def initialize
    @player = Participant.new("Player")
    @dealer = Participant.new("Dealer")
    @deck = Deck.new
  end

  def start
    display_hello
    loop do
      single_round
      round_reset
      break unless play_again?
    end
    display_goodbye
  end

  private

  def show_initial_card
    puts "Player have #{player.show_hand} for a total of #{player.hand.total}"
    puts "Dealer have #{dealer.show_hand(1)}"
  end

  def prompt_player
    reply = ''
    loop do
      puts "Would Player like to [hit] or [stay]?"
      reply = gets.chomp.downcase
      break if %w(hit stay).include? reply
      puts "Invalid choices"
    end
    reply
  end

  def show_cards
    puts "Player have #{player.show_hand} for a total of #{player.hand.total}"
    puts "Dealer have #{dealer.show_hand} for a total of #{dealer.hand.total}"
  end

  def show_result
    show_cards
    player_hand = player.hand.total
    dealer_hand = dealer.hand.total

    if player_hand > dealer_hand
      puts "Player won!"
    elsif player_hand < dealer_hand
      puts "Dealer won!"
    else
      puts "It's a tie!"
    end
  end

  def display_hello
    puts "Welcome to 21."
  end

  def display_goodbye
    puts "Thanks for playing 21."
  end

  def play_again?
    answer = ''
    loop do
      puts "Do player like to play again? (y or n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Please input 'y' or 'n' only"
    end
    answer == 'y'
  end

  def round_reset
    initialize
  end

  def player_turn
    while !player.busted?
      reply = prompt_player
      if reply == 'hit'
        deal(player)
        puts "Player choose to hit."
      else
        puts "Player choose to stay."
        break
      end
      puts "Player now have #{player.show_hand} for a total\
 of #{player.hand.total}."
    end
    check_busted(player)
  end

  def initial_deal
    2.times do
      player.hand.get_card(deck.deal)
      dealer.hand.get_card(deck.deal)
    end
  end

  def deal(participant)
    participant.hand.get_card(deck.deal)
  end

  def check_busted(participant)
    if participant.busted?
      puts "#{participant.name} have busted with a card of \
#{participant.show_hand} for a total of #{participant.hand.total}"
    end
  end

  def single_round
    loop do
      initial_deal
      show_initial_card
      player_turn
      break if player.busted?
      dealer_turn
      break if dealer.busted?
      show_result
      break
    end
  end

  def dealer_turn
    counter = 0
    while !dealer.busted? && dealer.less_than_17?
      deal(dealer)
      counter += 1
      puts "Dealer hit #{counter} times"
    end
    check_busted(dealer)
  end
end

Game.new.start
