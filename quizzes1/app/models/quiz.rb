class Quiz < ActiveRecord::Base
  has_many :question
  belongs_to :user
end
