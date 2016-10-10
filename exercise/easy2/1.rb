class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

#you can called a method from inside the class.

oracle = Oracle.new
p oracle.predict_the_future