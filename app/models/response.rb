class Response < ActiveRecord::Base
	belongs_to :question
	belongs_to :user

	validates_inclusion_of :is_yes, :in => [true, false]

	def serializable_hash(options = nil)
	  options ||= {}
	  response = {id: id, is_yes: is_yes, created_at: created_at, updated_at: updated_at}
	  response[:user] = self.user
	  response
	end

end
