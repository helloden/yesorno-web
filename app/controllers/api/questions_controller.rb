module Api
	class QuestionsController < BaseApiController

		def index
			render json: { results: Question.all }
		end

		def my_questions
			results = {results:[]}
			if user_signed_in?
				results[:results] = Question.where(user_id: current_user.id)
			end
			render json: results
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

	    render json: result.to_json, status: :created
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