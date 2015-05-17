class AddQuestionImageToQuestion < ActiveRecord::Migration
  def change
    add_attachment :questions, :question_image
  end
end
