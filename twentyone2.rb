require 'pry'
class Participant
  attr_accessor :hand

  def initialize
    @hand = []
  end

  def joiner(str_arr)
    str_arr[-1] = str_arr[-1].prepend("and ")
    str_arr
  end

  def show_hand(number = hand.size)
    on_hand = joiner(hand.collect(&:formatted_value))
    covered_hand = on_hand.slice(0, number)
    covered_hand.size > 2 ? covered_hand.join(", ") : covered_hand.join(" ")
  end

  def adjust_for_aces(total)
    deduction = 0
    num_of_aces = hand.select(&:ace?).count
    num_of_aces.times do
      break if total > 21
      deduction += 10
      total -= 10
    end
    deduction
  end

  def total
    sum = 0
    hand.each do |card|
      card_value = card.value[1]
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

  def busted?
    total > 21
  end
end

class Player < Participant
end

class Dealer < Participant
  def less_than_17?
    total < 17
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
  attr_reader :deck
  attr_accessor :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
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

  def initial_deal
    2.times do
      player.hand << deck.deal
      dealer.hand << deck.deal
    end
  end

  def deal(participant)
    participant.hand << deck.deal
  end

  def show_initial_card
    puts "You have #{player.show_hand} for a total of #{player.total}"
    puts "Dealer have #{dealer.show_hand(1)}"
  end

  def prompt_player
    reply = ''
    loop do
      puts "Would you like to [hit] or [stay]?"
      reply = gets.chomp.downcase
      break if %w(hit stay).include? reply
      puts "Invalid choices"
    end
    reply
  end

  def player_turn
    while !player.busted?
      reply = prompt_player
      if reply == 'hit'
        deal(player)
        puts "You choose to hit."
      else
        puts "You choose to stay."
        break
      end
      puts "You now have #{player.show_hand} for a total of #{player.total}."
    end

    if player.busted?
      puts "You have busted"
    end
  end

  def dealer_turn
    counter = 0
    while !dealer.busted? && dealer.less_than_17?
      deal(dealer)
      counter += 1
      puts "Dealer hit #{counter} times"
    end

    if dealer.busted?
      puts "Dealer busted with a hand of #{dealer.show_hand} \
for a total of #{dealer.total}"
    end
  end

  def show_cards
    puts "You have #{player.show_hand} for a total of #{player.total}"
    puts "Dealer have #{dealer.show_hand} for a total of #{dealer.total}"
  end

  def show_result
    show_cards

    if player.total > dealer.total
      puts "You won!"
    elsif player.total < dealer.total
      puts "Dealer won!"
    else
      puts "It's a tie!"
    end
  end

  def display_hello
    puts "welcome to 21."
  end

  def display_goodbye
    puts "Thanks for playing 21."
  end

  def play_again?
    answer = ''
    loop do
      puts "Do you like to play again? (y or n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Please input 'y' or 'n' only"
    end
    answer == 'y'
  end

  def round_reset
    initialize
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
end

Game.new.start
