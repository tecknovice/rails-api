class ApplicationController < ActionController::API
  # Set default response format to JSON
  before_action :set_default_format
  
  private
  
  def set_default_format
    request.format = :json
  end
end
