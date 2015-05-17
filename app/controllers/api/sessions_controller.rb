module Api
	class SessionsController < Devise::SessionsController
		skip_before_filter :verify_authenticity_token, if: :json_request?

	  acts_as_token_authentication_handler_for User

	  skip_before_filter :authenticate_entity_from_token!
	  skip_before_filter :authenticate_entity!
	  before_filter :authenticate_entity_from_token!, :only => [:destroy]
	  before_filter :authenticate_entity!, :only => [:destroy]


	  def create
	    warden.authenticate!(:scope => resource_name)
	    @user = current_user
	    render json: { message: 'Logged in', auth_token: @user.authentication_token}, status: :HTTP_OK
	  end

	  private

	  def json_request?
	    request.format.json?
	  end

	end
end