require "test_helper"

module Api
  module Admin
    class UsersControllerTest < ActionDispatch::IntegrationTest
      setup do
        # Set up admin user and token
        @admin = users(:admin)
        @admin_token = JsonWebToken.encode(user_id: @admin.id, role: @admin.role)
        
        # Set up regular user and token
        @regular_user = users(:user_one)
        @user_token = JsonWebToken.encode(user_id: @regular_user.id, role: @regular_user.role)
        
        # User to be updated in tests
        @user_to_update = users(:user_two)
      end
      
      # Index tests
      test "should list all users for admin" do
        get api_admin_users_url, headers: admin_headers, as: :json
        
        assert_response :success
        assert_equal User.count, json_response.size
      end
      
      test "should not allow regular users to list all users" do
        get api_admin_users_url, headers: user_headers, as: :json
        
        assert_response :forbidden
      end
      
      # Show tests
      test "should show user details for admin" do
        get api_admin_user_url(@regular_user), headers: admin_headers, as: :json
        
        assert_response :success
        assert_equal @regular_user.id, json_response['id']
        assert_equal @regular_user.email, json_response['email']
      end
      
      test "should not show user details for regular users" do
        get api_admin_user_url(@regular_user), headers: user_headers, as: :json
        
        assert_response :forbidden
      end
      
      # Update tests
      test "should update user when admin" do
        put api_admin_user_url(@user_to_update), 
            params: { name: "Admin Updated Name" }, 
            headers: admin_headers, 
            as: :json
        
        assert_response :success
        assert_equal "Admin Updated Name", json_response['name']
        
        # Reload from database to ensure it was updated
        @user_to_update.reload
        assert_equal "Admin Updated Name", @user_to_update.name
      end
      
      test "should update user role when admin" do
        # Ensure user is not admin initially
        assert_equal "user", @user_to_update.role
        
        put api_admin_user_url(@user_to_update), 
            params: { role: "admin" }, 
            headers: admin_headers, 
            as: :json
        
        assert_response :success
        assert_equal "admin", json_response['role']
        
        # Reload from database to ensure it was updated
        @user_to_update.reload
        assert_equal "admin", @user_to_update.role
      end
      
      test "should not update user when regular user" do
        put api_admin_user_url(@user_to_update), 
            params: { name: "Regular Updated Name" }, 
            headers: user_headers, 
            as: :json
        
        assert_response :forbidden
      end
      
      # Delete tests  
      test "should delete user when admin" do
        assert_difference('User.count', -1) do
          delete api_admin_user_url(@user_to_update), headers: admin_headers, as: :json
        end
        
        assert_response :success
      end
      
      test "should not delete user when regular user" do
        assert_no_difference('User.count') do
          delete api_admin_user_url(@user_to_update), headers: user_headers, as: :json
        end
        
        assert_response :forbidden
      end
      
      private
      
      def admin_headers
        # Make sure we're using the exact format our controllers expect
        { 'Authorization' => "Bearer #{@admin_token}" }
      end
      
      def user_headers
        # Make sure we're using the exact format our controllers expect
        { 'Authorization' => "Bearer #{@user_token}" }
      end
      
      def json_response
        JSON.parse(response.body)
      end
    end
  end
end
