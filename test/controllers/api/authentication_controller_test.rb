require "test_helper"

module Api
  class AuthenticationControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user_params = { 
        email: "newuser@example.com", 
        password: "password123", 
        name: "New Test User" 
      }
    end
    
    # Registration tests
    test "should register a new user" do
      assert_difference('User.count') do
        post api_register_url, params: @user_params, as: :json
      end
      
      assert_response :created
      assert_not_nil json_response['token']
      assert_equal "New Test User", json_response['user']['name']
      assert_equal "user", json_response['user']['role']
    end
    
    test "should not register user with invalid data" do
      # Missing email
      invalid_params = @user_params.except(:email)
      
      assert_no_difference('User.count') do
        post api_register_url, params: invalid_params, as: :json
      end
      
      assert_response :unprocessable_entity
    end
    
    # Login tests
    test "should login with valid credentials" do
      # Use fixture user
      post api_login_url, params: { 
        email: users(:user_one).email, 
        password: "password123" 
      }, as: :json
      
      assert_response :success
      assert_not_nil json_response['token']
      assert_equal users(:user_one).email, json_response['user']['email']
    end
    
    test "should not login with invalid credentials" do
      post api_login_url, params: { 
        email: users(:user_one).email, 
        password: "wrong_password" 
      }, as: :json
      
      assert_response :unauthorized
    end
    
    private
    
    def json_response
      JSON.parse(response.body)
    end
  end
end
