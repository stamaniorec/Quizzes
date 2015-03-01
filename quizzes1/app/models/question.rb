class Question < ActiveRecord::Base
  belongs_to :quiz

  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers, reject_if: :reject_questions, allow_destroy: true

  validates :question, presence: true
  validate :not_more_than_one_correct_answer, :at_least_one_correct_answer

  private

  def reject_questions(attrs)
  	attrs['value'].blank?
  end

  def not_more_than_one_correct_answer
    num_correct = 0
    answers.each { |a| num_correct += 1 if a.is_correct? }

    if num_correct > 1
      self.errors.add(:answers, "There can only be ONE correct answer: #{self.question}")
      false
    end
    true
  end

  def at_least_one_correct_answer
  	num_correct = 0
  	answers.each { |a| num_correct += 1 if a.is_correct? }

    if num_correct == 0
      self.errors.add(:answers, "There must be at least ONE correct answer: #{self.question}")
      false
    end
    true
  end
end
