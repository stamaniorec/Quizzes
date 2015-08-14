class AddUserIdToScores < ActiveRecord::Migration
  def change
  	change_table :scores do |t|
      t.integer :user_id
    end
  end
end
