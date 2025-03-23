module Authenticable
  extend ActiveSupport::Concern

  included do
    # Make current_user method available to views
    helper_method :current_user if respond_to?(:helper_method)
    
    # Set current user from token before each action
    before_action :authenticate_request
  end

  private

  def authenticate_request
    @current_user = authorize_request
  rescue ExceptionHandler::AuthenticationError, ExceptionHandler::MissingToken, ExceptionHandler::InvalidToken
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end

  def authorize_request
    @decoded = JsonWebToken.decode(http_auth_header)
    user = User.find(@decoded[:user_id])
    raise ExceptionHandler::AccessDenied if requires_admin? && !user.admin?
    user
  end

  def http_auth_header
    if request.headers['Authorization'].present?
      return request.headers['Authorization'].split(' ').last
    end
    raise ExceptionHandler::MissingToken, 'Missing token'
  end

  def current_user
    @current_user
  end

  def requires_admin?
    false
  end
end
