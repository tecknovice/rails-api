module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class AccessDenied < StandardError; end
  class BadRequest < StandardError; end
  class ResourceConflict < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
    rescue_from ExceptionHandler::AccessDenied, with: :forbidden
    rescue_from ExceptionHandler::BadRequest, with: :bad_request
    rescue_from ExceptionHandler::ResourceConflict, with: :conflict
    rescue_from ActionController::ParameterMissing, with: :bad_request
  
    # Handle other errors
    rescue_from StandardError do |e|
      # Log the error with backtrace for internal debugging
      Rails.logger.error("Internal Server Error: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      
      render json: { 
        error: "An unexpected error occurred", 
        code: "internal_server_error",
        status: 500 
      }, status: :internal_server_error
    end
  end

  private

  # Status code 400 - bad request
  def bad_request(e)
    log_error(e, :bad_request)
    render json: { 
      error: e.message || "Bad request", 
      code: "bad_request",
      status: 400 
    }, status: :bad_request
  end
  
  # Status code 409 - conflict
  def conflict(e)
    log_error(e, :conflict)
    render json: { 
      error: e.message || "Resource conflict", 
      code: "conflict",
      status: 409 
    }, status: :conflict
  end

  # Status code 422 - unprocessable entity
  def unprocessable_entity(e)
    log_error(e, :unprocessable_entity)
    
    # Extract validation errors if available
    errors = e.respond_to?(:record) && e.record.respond_to?(:errors) ? 
             e.record.errors.full_messages : 
             [e.message]
             
    render json: { 
      error: "Validation failed", 
      details: errors,
      code: "validation_failed",
      status: 422 
    }, status: :unprocessable_entity
  end

  # Status code 404 - not found
  def not_found(e)
    log_error(e, :not_found)
    render json: { 
      error: "Resource not found", 
      code: "not_found",
      status: 404 
    }, status: :not_found
  end

  # Status code 401 - unauthorized
  def unauthorized_request(e)
    log_error(e, :unauthorized)
    render json: { 
      error: "Not Authorized", 
      code: "unauthorized",
      status: 401 
    }, status: :unauthorized
  end
  
  # Status code 403 - forbidden
  def forbidden(e)
    log_error(e, :forbidden)
    render json: { 
      error: "Access denied", 
      code: "forbidden",
      status: 403 
    }, status: :forbidden
  end
  
  # Helper method to log errors consistently
  def log_error(exception, status)
    Rails.logger.info("#{status.to_s.upcase} Response: #{exception.class} - #{exception.message}")
  end
end
