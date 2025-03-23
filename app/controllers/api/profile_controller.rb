module Api
  class ProfileController < BaseController
    # GET /api/profile
    def show
      json_response(user_details(current_user))
    end
    
    # PUT /api/profile
    def update
      if current_user.update(profile_params)
        json_response(user_details(current_user))
      else
        json_response({ error: current_user.errors.full_messages }, :unprocessable_entity)
      end
    end
    
    private
    
    def profile_params
      # Allow password update only if it's provided
      if params[:password].present?
        params.permit(:name, :email, :password)
      else
        params.permit(:name, :email)
      end
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
