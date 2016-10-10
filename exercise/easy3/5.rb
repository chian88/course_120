class Television
  def self.manufacturer
    
  end
  
  def model
    
  end
end

tv = Television.new
tv.manufacturer # can't work because #manufacturer is a class method.
tv.model        # will work because #model is a instance method.

Television.manufacturer  # will work because #manufacturer is a class method.
Television.model # can't work because #model is a instance method.