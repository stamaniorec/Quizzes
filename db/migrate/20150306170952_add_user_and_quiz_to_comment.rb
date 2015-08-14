class AddUserAndQuizToComment < ActiveRecord::Migration
  def change
  	change_table :comments do |t|
  		t.references :quiz
  		t.references :user
  	end
  end
end
