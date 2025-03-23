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
    auth_result = authorize_request
    
    # Handle authentication result
    if auth_result.is_a?(Hash)
      # Set current user from auth result
      @current_user = auth_result[:user]
      
      # Handle authorization failure (valid user but lacking privileges)
      unless auth_result[:authorized]
        # User is authenticated but not authorized for admin action
        Rails.logger.info("Authorization failed for user: #{@current_user.id}")
        render json: { 
          error: 'Access denied', 
          code: 'forbidden',
          status: 403 
        }, status: :forbidden
        return false
      end
      
      # Authorization successful
      return true
    end
  rescue ExceptionHandler::AuthenticationError, ExceptionHandler::MissingToken, ExceptionHandler::InvalidToken => e
    # Log the error for debugging purposes
    Rails.logger.info("Authentication failed: #{e.class.name} - #{e.message}")
    
    # Return proper status code directly instead of re-raising
    render json: { 
      error: 'Not Authorized', 
      code: 'unauthorized',
      status: 401 
    }, status: :unauthorized
    return false
  end

  def authorize_request
    token = http_auth_header
    begin
      @decoded = JsonWebToken.decode(token)
      user = User.find(@decoded[:user_id])
      
      # Verify user exists and is active
      raise ExceptionHandler::InvalidToken, 'Invalid user' unless user
      
      # Check admin privileges if required
      if requires_admin? && !user.admin?
        Rails.logger.info("Access denied for user id: #{user.id}, role: #{user.role}")
        # Don't raise an exception, return user but indicate authorization issue
        return { user: user, authorized: false }
      end
      
      # Return user with authorization success
      { user: user, authorized: true }
    rescue ActiveRecord::RecordNotFound => e
      # A more specific error for user not found
      Rails.logger.info("User from token not found: #{e.message}")
      raise ExceptionHandler::InvalidToken, 'Invalid token: User not found'
    rescue JWT::DecodeError => e
      # Handle JWT library errors
      Rails.logger.info("Token decode error: #{e.message}")
      raise ExceptionHandler::InvalidToken, 'Invalid or expired token'
    end
  end

  def http_auth_header
    if request.headers['Authorization'].present?
      header = request.headers['Authorization']
      # Allow Bearer token format or raw token
      return header.start_with?('Bearer ') ? header.split(' ').last : header
    end
    raise ExceptionHandler::MissingToken, 'Missing authentication token'
  end

  def current_user
    @current_user
  end

  def requires_admin?
    false
  end
  
  # Helper methods for authentication responses
  def user_details(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
