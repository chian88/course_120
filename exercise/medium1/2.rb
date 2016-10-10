class InvoiceEntry
  attr_accessor :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    @quantity = updated_count if updated_count >= 0  #this will create a local variable quantity. Need to refer as @quantity.
  end
end

# to address the issues, create attr_accessor :quantity , then self.quantity = updated_count.

invoice1 = InvoiceEntry.new("rubberduck", 2)
p invoice1.quantity
invoice1.update_quantity(5)
p invoice1.quantity