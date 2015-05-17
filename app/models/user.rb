class User < ActiveRecord::Base
	has_many :questions
	has_many :responses

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	acts_as_token_authenticatable

end
