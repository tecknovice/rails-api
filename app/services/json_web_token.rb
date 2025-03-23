# JsonWebToken service handles JWT token generation and verification
class JsonWebToken
  # Use Rails secret key for signing tokens
  SECRET_KEY = Rails.application.credentials.secret_key_base
  
  # Token expiration time (24 hours as specified in design doc)
  TOKEN_EXPIRY = 24.hours
  
  # Encode a new JWT token
  # @param payload [Hash] Data to encode in the token
  # @param exp [Time] Token expiration time (defaults to 24 hours)
  # @return [String] Encoded JWT token
  def self.encode(payload, exp = TOKEN_EXPIRY.from_now)
    # Add expiration time to payload
    payload[:exp] = exp.to_i
    # Add issued-at time for token freshness checks
    payload[:iat] = Time.now.to_i
    
    # Encode token with HS256 algorithm
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end
  
  # Decode and verify a JWT token
  # @param token [String] JWT token to decode
  # @return [HashWithIndifferentAccess] Decoded token payload
  # @raise [ExceptionHandler::InvalidToken] If token is invalid or expired
  def self.decode(token)
    # Decode the token, verify signature and expiration
    begin
      decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })[0]
      HashWithIndifferentAccess.new(decoded)
    rescue JWT::ExpiredSignature
      # Handle expired token specifically
      Rails.logger.info("Token expired")
      raise ExceptionHandler::InvalidToken, 'Authentication token has expired'
    rescue JWT::DecodeError => e
      # Handle other decode errors
      Rails.logger.info("Token decode error: #{e.message}")
      raise ExceptionHandler::InvalidToken, 'Invalid authentication token'
    rescue JWT::VerificationError
      # Handle signature verification failure
      Rails.logger.info("Token verification failed")
      raise ExceptionHandler::InvalidToken, 'Token verification failed'
    end
  end
  
  # Check if a token is valid without raising exceptions
  # @param token [String] JWT token to validate
  # @return [Boolean] True if token is valid, false otherwise
  def self.valid_token?(token)
    begin
      decode(token)
      true
    rescue
      false
    end
  end
end
