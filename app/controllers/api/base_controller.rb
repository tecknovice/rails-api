module Api
  class BaseController < ApplicationController
    include ExceptionHandler
    include Authenticable
    
    # Return JSON response with status
    def json_response(object, status = :ok)
      render json: object, status: status
    end
  end
end
