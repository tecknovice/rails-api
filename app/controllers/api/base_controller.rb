module Api
  class BaseController < ApplicationController
    include ExceptionHandler
    include Authenticable
    
    # Add authentication by default for all API endpoints
    before_action :authenticate_request, unless: :skip_authentication?
    
    # Return JSON response with status
    def json_response(object, status = :ok)
      render json: object, status: status
    end
    
    private
    
    # Override in controllers that don't require authentication
    def skip_authentication?
      false
    end
  end
end
