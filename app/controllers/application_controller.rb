class ApplicationController < ActionController::Base

  DEFAULT_LIMIT = 50

  rescue_from Bigcommerce::NotFound do
    redirect_to root_path
  end

  protected

  def set_current_page
    @current_page = params[:page] || 1
    @current_limit = params[:limit] || DEFAULT_LIMIT
  end
end
