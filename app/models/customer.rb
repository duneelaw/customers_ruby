class Customer < ApplicationModel
  attr_accessor :id, :first_name, :last_name, :email

  validates :first_name, :last_name, :email, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def lifetime_value
    @ltv ||= LifetimeValueCalculator.new(orders).value
  end

  def orders
    @orders ||= Order.all(customer_id: id)
  end

  def orders_count
    orders.size
  end

  def currency_code
    orders.first&.currency_code
  end
  
  # The 'all' method should be normally used from the superclass
  # ---> THAT IS THE OFFICIAL IMPLEMENTATION! <---
  
  # Althougth, in order to show that I can respond to a contextual issue,
  # I also created this ovverride that should NEVER be used in real life.
  
  # The issue that I found is that each order takes several seconds to 
  # fetch, and only a few users have orders
  # As a pure excercise I tried to eager load the orders per customer
  # but only when using a specific parameter 'eager_load_orders'
  
  def self.all(parameters)
    eager_load_orders = parameters.delete(:eager_load_orders)
    super(parameters).tap do |customers|
      if eager_load_orders
        orders = Order.all.group_by(&:customer_id)
        customers.each do |c|
          c.instance_eval { @orders = orders[c.id].to_a }
        end
      end
    end
  end
end
