module Api
	class SessionsController < Devise::SessionsController
		protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
		skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

		before_filter :validate_auth_token, :except => :create
		include Devise::Controllers::Helpers
	  include ApiHelper

	  def create
	    resource = User.find_for_database_authentication(:email => params[:user][:email])
	    return failure unless resource

	    if resource.valid_password?(params[:user][:password])
	      sign_in(:user, resource)

	      resource.ensure_authentication_token!
	      render :json=> {:success => true, :token => resource.authentication_token}
	      return
	    end
	    failure
	  end


	end
end