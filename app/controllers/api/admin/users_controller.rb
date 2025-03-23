module Api
  module Admin
    class UsersController < BaseController
      before_action :set_user, only: [:show, :update, :destroy]
      
      # GET /api/admin/users
      def index
        @users = User.all
        json_response(@users.map { |user| user_details(user) })
      end
      
      # GET /api/admin/users/:id
      def show
        json_response(user_details(@user))
      end
      
      # PUT /api/admin/users/:id
      def update
        if @user.update(user_params)
          json_response(user_details(@user))
        else
          json_response({ error: @user.errors.full_messages }, :unprocessable_entity)
        end
      end
      
      # DELETE /api/admin/users/:id
      def destroy
        @user.destroy
        json_response({ message: 'User deleted successfully' })
      end
      
      private
      
      def set_user
        @user = User.find(params[:id])
      end
      
      def user_params
        params.permit(:name, :email, :role)
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
end
