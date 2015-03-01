class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers , primary_key: "answer_id", force: :cascade do |t|
    	t.integer :question_id
    	t.string :value
    	t.boolean :is_correct
    end
    add_index "answers", ["question_id"], name: "question_id", using: :btree
  end
end
