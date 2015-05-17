module Api
	class RegistrationsController < Devise::RegistrationsController
		protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

		def create
			build_resource(sign_up_params)
	    resource.save
	    yield resource if block_given?
	    if resource.persisted?
	      if resource.active_for_authentication?
	        sign_up(resource_name, resource)
	      	warden.authenticate!(:scope => resource_name)
			    @user = current_user
			    render json: { message: 'Logged in', auth_token: @user.authentication_token}, status: :created

	      else
	        # expire_data_after_sign_in!
	        render json: resource, status: :created
	      end
	    else
	      clean_up_passwords resource
	      # set_minimum_password_length
	      logger.debug "Errors: "
	      logger.debug resource.errors.full_messages
	      render json: { errors: resource.errors.full_messages} , status: :unprocessable_entity
	    end
		end

		private

	  def sign_up_params
	    params.require(:user).permit(:email, :password, :password_confirmation, :username)
	  end

	  def json_request?
	    request.format.json?
	  end

	end
end