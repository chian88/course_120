class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

hot_pizza = Pizza.new("cheese")
orange = Fruit.new("orange")

p hot_pizza.instance_variables
p orange.instance_variables