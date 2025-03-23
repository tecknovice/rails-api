require "test_helper"

module Api
  class ProfileControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:user_one)
      @token = JsonWebToken.encode(user_id: @user.id, role: @user.role)
    end
    
    # Get profile tests
    test "should get user profile when authenticated" do
      get api_profile_url, headers: auth_headers, as: :json
      
      assert_response :success
      assert_equal @user.id, json_response['id']
      assert_equal @user.email, json_response['email']
      assert_equal @user.name, json_response['name']
    end
    
    test "should not get profile when not authenticated" do
      get api_profile_url, as: :json
      
      assert_response :unauthorized
    end
    
    # Update profile tests
    test "should update user profile" do
      put api_profile_url, 
          params: { name: "Updated Name" }, 
          headers: auth_headers, 
          as: :json
      
      assert_response :success
      assert_equal "Updated Name", json_response['name']
      
      # Reload from database to ensure it was updated
      @user.reload
      assert_equal "Updated Name", @user.name
    end
    
    test "should update user email" do
      put api_profile_url, 
          params: { email: "updated@example.com" }, 
          headers: auth_headers, 
          as: :json
      
      assert_response :success
      assert_equal "updated@example.com", json_response['email']
      
      # Reload from database to ensure it was updated
      @user.reload
      assert_equal "updated@example.com", @user.email
    end
    
    test "should update user password" do
      put api_profile_url, 
          params: { password: "newpassword123" }, 
          headers: auth_headers, 
          as: :json
      
      assert_response :success
      
      # Reload user and check if new password works
      @user.reload
      assert @user.authenticate("newpassword123"), "Password was not updated correctly"
    end
    
    test "should not update with invalid data" do
      put api_profile_url, 
          params: { email: "invalid-email" }, 
          headers: auth_headers, 
          as: :json
      
      assert_response :unprocessable_entity
    end
    
    private
    
    def auth_headers
      # Use Bearer token format for consistency
      { 'Authorization' => "Bearer #{@token}" }
    end
    
    def json_response
      JSON.parse(response.body)
    end
  end
end
