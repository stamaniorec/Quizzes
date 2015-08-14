class AddBodyToComments < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      t.text :body
    end
  end
end
