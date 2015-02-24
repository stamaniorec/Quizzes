class Quiz < ActiveRecord::Base
  has_many :question
  has_many :scores
  belongs_to :user
end
