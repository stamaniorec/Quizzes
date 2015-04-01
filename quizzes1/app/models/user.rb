class User < ActiveRecord::Base
  has_merit

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :quizzes
  has_many :scores
  has_many :comments
  
  scoped_search :on => :email

  acts_as_voter
end
