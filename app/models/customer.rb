class Customer < ApplicationModel
  attr_accessor :id, :first_name, :last_name, :email

  validates :first_name, :last_name, :email, presence: true

  # ovverrides in order to eager load orders
  # because each order takes 2 secons to fetch
  # but of course, don't try this at home!
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
end
