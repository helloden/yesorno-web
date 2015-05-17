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
	      	render json: resource, status: :created

	      else
	        expire_data_after_sign_in!
	        render json: resource, status: :created
	      end
	    else
	      clean_up_passwords resource
	      # set_minimum_password_length
	      render json: { errors: resource.errors.full_messages} , status: :unprocessable_entity
	    end
		end

		protected

			def build_resource(hash=nil)
		    self.resource = resource_class.new_with_session(hash || {}, session)
		  end

			def sign_up_params
		    devise_parameter_sanitizer.sanitize(:sign_up)
		  end
	end
end