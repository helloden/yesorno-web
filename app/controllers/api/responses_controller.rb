module Api
	class ResponsesController < BaseApiController

		def index
			responses = Response.where(question_id: params[:question_id])
			render json: responses
		end

		def create
			response = Response.new(response_params)
			response.question_id = params[:question_id]
			response.user = current_user
			if response.save
				render json: response, status: :created
			else
				render json: { errors: response.errors.full_messages}, status: :unprocessable_entity
			end
		end

		private
			def response_params
      	params.require(:response).permit(:is_yes)
    	end
	end
end