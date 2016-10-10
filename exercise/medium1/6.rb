class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"  #directly changes the instance variable
  end

  def show_template
    template                    # use the getter method to get to instance variable.
  end
end

class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231" # use the setter method to change the template instance variable.
  end

  def show_template
    self.template                     # also uses getter method to get to the instance variable. redundant.
  end
end