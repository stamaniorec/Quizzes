class LongerQuestionPrompt < ActiveRecord::Migration
  def up
  	change_table :questions do |t|
      t.change :question, :string, :limit => 150
    end
  end
end
