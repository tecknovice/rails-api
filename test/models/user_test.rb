require "test_helper"

class UserTest < ActiveSupport::TestCase
  # Validations tests
  test "should not save user without email" do
    user = User.new(name: "Test User", password: "password123", role: "user")
    assert_not user.save, "Saved user without email"
  end
  
  test "should not save user without password on create" do
    user = User.new(name: "Test User", email: "valid@example.com", role: "user")
    assert_not user.save, "Saved user without password"
  end
  
  test "should not save user without name" do
    user = User.new(email: "valid@example.com", password: "password123", role: "user")
    assert_not user.save, "Saved user without name"
  end
  
  test "should not save user with invalid role" do
    user = User.new(
      name: "Test User",
      email: "valid@example.com", 
      password: "password123", 
      role: "invalid_role"
    )
    assert_not user.save, "Saved user with invalid role"
  end
  
  test "should not save user with duplicate email" do
    user1 = User.new(
      name: "First User",
      email: "duplicate@example.com", 
      password: "password123", 
      role: "user"
    )
    user1.save
    
    user2 = User.new(
      name: "Second User",
      email: "duplicate@example.com", 
      password: "password123", 
      role: "user"
    )
    assert_not user2.save, "Saved user with duplicate email"
  end
  
  test "should not save user with invalid email format" do
    user = User.new(
      name: "Test User",
      email: "invalid-email", 
      password: "password123", 
      role: "user"
    )
    assert_not user.save, "Saved user with invalid email format"
  end
  
  test "should not save user with short password" do
    user = User.new(
      name: "Test User",
      email: "valid@example.com", 
      password: "short", 
      role: "user"
    )
    assert_not user.save, "Saved user with too short password"
  end
  
  # Authentication tests
  test "should authenticate with correct password" do
    user = User.new(
      name: "Auth Test",
      email: "auth@example.com", 
      password: "password123", 
      role: "user"
    )
    user.save
    assert user.authenticate("password123"), "Failed to authenticate with correct password"
  end
  
  test "should not authenticate with incorrect password" do
    user = User.new(
      name: "Auth Test",
      email: "auth2@example.com", 
      password: "password123", 
      role: "user"
    )
    user.save
    assert_not user.authenticate("wrong_password"), "Authenticated with incorrect password"
  end
  
  # Role tests
  test "admin? should return true for admin users" do
    admin = users(:admin)
    assert admin.admin?, "admin? returned false for admin user"
  end
  
  test "admin? should return false for non-admin users" do
    user = users(:user_one)
    assert_not user.admin?, "admin? returned true for non-admin user"
  end
  
  test "user? should return true for regular users" do
    user = users(:user_one)
    assert user.user?, "user? returned false for regular user"
  end
  
  test "user? should return false for admin users" do
    admin = users(:admin)
    assert_not admin.user?, "user? returned true for admin user"
  end
end
