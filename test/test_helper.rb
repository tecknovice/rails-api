ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Make sure the fixtures match bcrypt encrypted passwords format
# This is to ensure passwords in fixtures work correctly
BCrypt::Engine.cost = BCrypt::Engine::MIN_COST

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    
    # Helper method to parse JSON response
    def json_response
      JSON.parse(response.body)
    end
  end
end

module ActionDispatch
  class IntegrationTest
    # Helper for creating auth headers with token
    def auth_headers_for(user)
      token = JsonWebToken.encode(user_id: user.id, role: user.role)
      { 'Authorization' => token }
    end
    
    # Creates a test JWT token with specified role
    def generate_token(user_id, role = 'user')
      JsonWebToken.encode(user_id: user_id, role: role) 
    end
    
    # Creates an auth header with Bearer prefix
    def auth_header(token)
      { 'Authorization' => token }
    end
  end
end
