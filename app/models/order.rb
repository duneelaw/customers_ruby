class Order < ApplicationModel
  attr_accessor :id, :customer_id, :status, :products, :date_created, :total_inc_tax, :currency_code

  def parse(key, value, obj)
    new_value = key.eql?(:total_inc_tax) ? BigDecimal.new(value) : value
    super(key, new_value, obj)
  end
end
