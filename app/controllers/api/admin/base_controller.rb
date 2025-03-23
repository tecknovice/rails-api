module Api
  module Admin
    class BaseController < Api::BaseController
      before_action :require_admin
      
      private
      
      def require_admin
        unless current_user.admin?
          raise ExceptionHandler::AccessDenied, 'Admin privileges required'
        end
      end
      
      def requires_admin?
        true
      end
    end
  end
end
