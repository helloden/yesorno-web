class Response < ActiveRecord::Base
	belongs_to :question

	validates_inclusion_of :is_yes, :in => [true, false]
end
