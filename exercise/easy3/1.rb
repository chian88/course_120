class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

hello = Hello.new
hello.hi  # prints "Hello"

hello = Hello.new
hello.bye  # no method error

hello = Hello.new
hello.greet    # expecting one argument but provided none.

hello = Hello.new
hello.greet("Goodbye")   # prints Goodbye

Hello.hi     # no class method available.