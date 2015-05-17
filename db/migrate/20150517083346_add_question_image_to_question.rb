class AddQuestionImageToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :question_image, :string
  end
end
