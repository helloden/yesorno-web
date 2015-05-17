class Question < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: :user_id

	has_many :responses

	has_attached_file :question_image , :styles => { :medium => "300x300>", :thumb => "100x100>"},
                    :url => "/images/:attachment/:id_:style.:extension",
                    :path => ":rails_root/public/images/:attachment/:id_:style.:extension"
                   # :default_url => "/images/Default_profile_picture.png"

	attr_accessor :question_image_file_name, :question_image_content, :question_image_content_type

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
