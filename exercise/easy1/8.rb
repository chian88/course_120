class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
    p self
  end
end

cat = Cat.new("persian")
cat.make_one_year_older

# self refers to the object instance.