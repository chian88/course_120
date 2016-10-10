module Movable
  attr_accessor :speed, :heading
  
  def range
    (@fuel_capacity * @fuel_efficiency)
  end
end

class WheeledVehicle

  include Movable

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

class SeaCraft 
  attr_accessor :propeller_count, :hull_count
  
  include Movable
  
  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    @num_propellers = num_propellers
    @num_hulls = num_hulls
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end
  
  def range
    fuel_range = super
    fuel_range + 10
  end
  
  
end

class Catamaran < SeaCraft
end

class Motorboat < SeaCraft
  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    super(1,1, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end


car = Auto.new
motorcycle = Motorcycle.new

cata = Catamaran.new(4, 4, 2, 20)
motorboat = Motorboat.new(20,40)
p cata.range
p motorboat.range
