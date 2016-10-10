class Cube
  attr_accessor :volume
    
  def initialize(volume)
    @volume = volume
  end
  
end

cube = Cube.new(12)
p cube.instance_variable_get("@volume")