# This file creates seed data for the application

# Clear existing users
puts 'Deleting existing users...'
User.delete_all

# Create admin user
puts 'Creating admin user...'
admin = User.new(
  name: 'Admin User',
  email: 'admin@example.com',
  password: 'password123',
  role: 'admin'
)
admin.save!

# Create regular users
puts 'Creating regular users...'
5.times do |i|
  User.create!(
    name: "User #{i+1}",
    email: "user#{i+1}@example.com",
    password: 'password123',
    role: 'user'
  )
end

puts 'Seed data created successfully!'
puts "Admin login: admin@example.com / password123"
puts "Sample user login: user1@example.com / password123"
