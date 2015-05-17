class Question < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: :user_id

	has_many :responses
	has_attached_file :question_image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
	attr_accessor :question_image_file_name

	validates :content, presence: true
	# validates :owner, presence: true

	def serializable_hash(options = nil)
	  options ||= {}
	  question = {id: id, content: content}
	  question[:user] = self.owner
	  question[:responses] = self.responses
	  question
	end

end
