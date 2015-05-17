module Api
	class QuestionsController < BaseApiController

		def index
			render json: Question.all
		end

		def show
			question = Question.where(id: params[:id])
			responses = Response.where(id: params[:id])
			render json: question
		end

		def create
			question = Question.new(question_params)
			if user_signed_in?
      	question.owner = current_user
    	end
			if question.save
				render json: question, status: :created
			else
				render json: { errors: question.errors.full_messages}, status: :unprocessable_entity
			end
		end

		def upload_image
			result = { status: "failed" }
			begin
	      question_params[:question_image] = parse_image_data(question_params[:question_image]) if question_params[:question_image]
	      question = Question.find(params[:question_id])
	      question.question_image = question_params[:question_image]

	      if question.save
	        result[:status] = "success"
	      end
	    rescue Exception => e
	      Rails.logger.error "#{e.message}"
	    end

	    render json: result.to_json
	  ensure
	    clean_tempfile
	  end

	# This part is actually taken from http://blag.7tonlnu.pl/blog/2014/01/22/uploading-images-to-a-rails-app-via-json-api. I tweaked it a bit by manually setting the tempfile's content type because somehow putting it in a hash during initialization didn't work for me.
	  def parse_image_data(image_data)
	    @tempfile = Tempfile.new('question_image')
	    @tempfile.binmode
	    @tempfile.write Base64.decode64(image_data[:content])
	    @tempfile.rewind

	    uploaded_file = ActionDispatch::Http::UploadedFile.new(
	      tempfile: @tempfile,
	      filename: image_data[:filename]
	    )

	   uploaded_file.content_type = image_data[:content_type]
	    uploaded_file
	  end

	  def clean_tempfile
	    if @tempfile
	      @tempfile.close
	      @tempfile.unlink
	    end
	  end

		private
			def question_params
      	# params.require(:question).permit(:content)
      	params.require(:question)
    	end
	end
end