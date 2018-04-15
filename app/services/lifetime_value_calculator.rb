class LifetimeValueCalculator
  attr_reader :orders

  def initialize(orders)
    @orders = orders || []
  end

  def value
    @value ||= calculate_value
  end

  def total_amount
    @total_amount ||= calculate_total_amount
  end

  def months
    @months ||= calculate_months
  end

  private

  # https://synerise.com/how-to-calculate-clv-index-discussion-of-historical-methods/
  def calculate_months
    calculate(0) { orders.collect{ |o| o.date_created.strftime('%Y%m') }.uniq.size }
  end

  # TODO: filter by status
  def calculate_total_amount
    calculate(0.0) { orders.collect(&:total_inc_tax).reduce(:+).to_d }
  end

  def calculate_value
    calculate(0.0) { (total_amount / months).to_d }
  end

  def calculate(default)
    orders.empty? ? default : yield
  end
end
