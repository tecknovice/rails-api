module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class AccessDenied < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
    rescue_from ExceptionHandler::AccessDenied, with: :forbidden
  
    # Handle other errors
    rescue_from StandardError do |e|
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  # Status code 422 - unprocessable entity
  def unprocessable_entity(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # Status code 404 - not found
  def not_found(e)
    render json: { error: e.message }, status: :not_found
  end

  # Status code 401 - unauthorized
  def unauthorized_request(e)
    render json: { error: e.message }, status: :unauthorized
  end
  
  # Status code 403 - forbidden
  def forbidden(e)
    render json: { error: 'Access denied' }, status: :forbidden
  end
end
