class InvoiceEntry
  attr_accessor :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    self.quantity = updated_count if updated_count >= 0
  end
end

invoice1 = InvoiceEntry.new("Teddy", 2)
p invoice1.quantity
invoice1.update_quantity(3)
p invoice1.quantity