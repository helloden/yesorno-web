module Api
	class QuestionsController < BaseApiController

		def index
			render json: { results: Question.all }
		end

		def show
			question = Question.where(id: params[:id])
			responses = Response.where(id: params[:id])
			render json: question
		end

		def create
			question = Question.new(question_params)
			result = { status: "failed" }

			if user_signed_in?
      	question.owner = current_user
    	end

    	begin
	      image = parse_image_data(params[:question][:question_image]) if params[:question][:question_image]
	      question.question_image = image

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

		def upload_image
			result = { status: "failed" }
			begin
	      image = parse_image_data(params[:question][:question_image]) if params[:question][:question_image]
	      question = Question.find(params[:question_id])
	      question.question_image = image

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
    @tempfile = Tempfile.new('question_question_image')
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
      	params.require(:question).permit(:content)
    	end
	end
end