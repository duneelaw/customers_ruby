module ApplicationHelper
  def format_amount(amount, currency)
    "#{amount.truncate(2)} #{currency}"
  end
end
