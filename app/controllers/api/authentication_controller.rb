module Api
  class AuthenticationController < BaseController
    skip_before_action :authenticate_request, only: [:register, :login]
    
    # POST /api/register
    def register
      @user = User.new(user_params)
      if @user.save
        token = JsonWebToken.encode(user_id: @user.id, role: @user.role)
        json_response({
          user: user_details(@user),
          token: token
        }, :created)
      else
        json_response({ error: @user.errors.full_messages }, :unprocessable_entity)
      end
    end
    
    # POST /api/login
    def login
      @user = User.find_by(email: params[:email])
      
      if @user && @user.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: @user.id, role: @user.role)
        json_response({
          user: user_details(@user),
          token: token
        })
      else
        raise ExceptionHandler::AuthenticationError, 'Invalid credentials'
      end
    end
    
    private
    
    def user_params
      params.permit(:email, :password, :name)
    end
    
    def user_details(user)
      {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        created_at: user.created_at
      }
    end
  end
end
