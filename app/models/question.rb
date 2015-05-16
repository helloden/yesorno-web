class Question < ActiveRecord::Base
	has_many :responses

	validates :content, presence: true

end
