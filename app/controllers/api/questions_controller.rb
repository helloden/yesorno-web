module Api
	class QuestionsController < BaseApiController
		before_filter :authenticate_user!

		def index
			render json: Question.all
		end

		def show
			question = Question.where(id: params[:id])
			responses = Response.where(id: params[:id])
			render json: question.as_json(include:[:responses])
		end

		def create
			question = Question.new(question_params)
			if user_signed_in?
      	@question.owner = current_user
    	end
			if question.save
				render json: question, status: :created
			else
				render json: { errors: question.errors.full_messages}, status: :unprocessable_entity
			end
		end

		def respond

		end

		private
			def question_params
      	params.require(:question).permit(:content)
    	end
	end
end