class Response < ActiveRecord::Base
	belongs_to :question
	belongs_to :user

	validates_inclusion_of :is_yes, :in => [true, false]

end
