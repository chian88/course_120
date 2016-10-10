class Cube
  attr_accessor :volume
    
  def initialize(volume)
    @volume = volume
  end
end

cube = Cube.new(12)

puts cube


