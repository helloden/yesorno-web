class Question < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: :user_id

	has_many :responses

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
