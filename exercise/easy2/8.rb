class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game   #inherts all method from Game class.
  def rules_of_play
    #rules of play
  end
end

bingo = Bingo.new
p bingo.play
