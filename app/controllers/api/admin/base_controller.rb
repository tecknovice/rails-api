module Api
  module Admin
    class BaseController < Api::BaseController
      # Just use the parent authenticate_request but add a simple admin check
      before_action :check_admin_privileges
      
      private
      
      # Simple method to ensure the user is an admin after authentication
      def check_admin_privileges
        # Skip if authentication already failed (no current_user)
        return unless current_user
        
        # Check admin privileges and return forbidden if not admin
        unless current_user.admin?
          Rails.logger.info("Admin access denied for user: #{current_user.id}, role: #{current_user.role}")
          render json: { 
            error: 'Access denied', 
            code: 'forbidden',
            status: 403 
          }, status: :forbidden
          return false # Important: return false to halt the action
        end
        true # Allow the action to continue
      end
      
      # Tell parent controller we need admin rights
      def requires_admin?
        true
      end
    end
  end
end
