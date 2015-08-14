class AddShuffledToQuiz < ActiveRecord::Migration
  def change
  	change_table :quizzes do |t|
      t.boolean :shuffled
    end
  end
end
