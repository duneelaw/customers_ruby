class CustomersController < ApplicationController
  before_action :set_current_page

  def index
    @customers = Customer.all(page: @current_page, limit: @current_limit, **options)
  end

  def show
    @customer = Customer.find(params[:id])
  end

  private

  def options
    { eager_load_orders: true }
  end
end
