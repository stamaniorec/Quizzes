class AddAnchoredToAnswers < ActiveRecord::Migration
  def change
  	change_table :answers do |t|
      t.boolean :anchored
    end
  end
end
