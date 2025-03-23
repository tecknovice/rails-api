class User < ApplicationRecord
  attr_accessor :password
  
  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :name, presence: true
  validates :role, inclusion: { in: %w[user admin] }
  
  # Callbacks
  before_save :encrypt_password, if: :password_present?
  
  # Define roles
  def admin?
    role == 'admin'
  end
  
  def user?
    role == 'user'
  end
  
  # Authentication methods
  def authenticate(password)
    BCrypt::Password.new(encrypted_password) == password
  end
  
  private
  
  def password_present?
    password.present?
  end
  
  def encrypt_password
    self.encrypted_password = BCrypt::Password.create(password)
  end
end
