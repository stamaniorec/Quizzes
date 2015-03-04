class AddTimeToScores < ActiveRecord::Migration
  def change
  	change_table :scores do |t|
      t.datetime :date
    end
  end
end
