class Cat
  @@cats_count = 0  # cats_counts is a class variables

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1   # it will plus 1 each time Cat class is initialized.
  end

  def self.cats_count
    @@cats_count     # you can retrieve class variables using class method.
  end
end

kitty = Cat.new("persian")
p Cat.cats_count   # you call a class method by calling the methods on the Class Name.