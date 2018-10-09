class AddQuestionsIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :questions, :title
    add_index :questions, :body
  end
end
