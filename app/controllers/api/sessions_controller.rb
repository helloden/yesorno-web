module Api
	class SessionsController < Devise::SessionsController
		skip_before_filter :verify_authenticity_token, if: :json_request?

	  acts_as_token_authentication_handler_for User, only: [:destroy],
    fallback_to_devise: false


	  def create
	    warden.authenticate!(:scope => resource_name)
	    @user = current_user
	    render json: { message: 'Logged in', auth_token: @user.authentication_token}, status: :created
	  end

	  def destroy
	    if user_signed_in?
	      @user = current_user
	      @user.authentication_token = nil
	      @user.save

        render json: {message: 'Logged out successfully.'}, status: :ok
	    else
        render json: { message: 'Failed to log out. User must be logged in.'}, status: :unauthorized
	    end
	  end

	  private

	  def json_request?
	    request.format.json?
	  end

	end
end