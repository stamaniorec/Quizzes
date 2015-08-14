class RemoveDateFromScores < ActiveRecord::Migration
  def change
  	remove_column :scores, :date
  end
end
