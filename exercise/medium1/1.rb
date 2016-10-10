class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

# Ben is right . No need for self here. Because the self is implicit.
# because Ben has created an attr_reader for balance. 

account1 = BankAccount.new(1200)
p account1.positive_balance?