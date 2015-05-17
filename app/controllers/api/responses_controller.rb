module Api
	class ResponsesController < BaseApiController

		def index
			responses = Response.where(question_id: params[:question_id])
			render json: { results: responses }
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

		def statistics
			num_yes = Response.where(question_id: params[:question_id], is_yes: true).count
			num_no = Response.where(question_id: params[:question_id], is_yes: false).count
			render json: { yes: num_yes, no: num_no }
		end

		private
			def response_params
      	params.require(:response).permit(:is_yes)
    	end
	end
end
