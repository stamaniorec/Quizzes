class RemoveAnswersFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :ans1, :string
    remove_column :questions, :ans2, :string
    remove_column :questions, :ans3, :string
    remove_column :questions, :ans4, :string
    remove_column :questions, :ans5, :string
    remove_column :questions, :ans6, :string
    remove_column :questions, :correct, :integer
  end
end
