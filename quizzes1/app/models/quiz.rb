class Quiz < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  has_many :scores, dependent: :destroy
  belongs_to :user

  has_many :comments, dependent: :destroy
  
  scoped_search on: :name
  scoped_search in: :user, on: :email
  scoped_search in: :questions, on: :question

  acts_as_votable
end
