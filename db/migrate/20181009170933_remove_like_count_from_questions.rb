class RemoveLikeCountFromQuestions < ActiveRecord::Migration[5.2]
  def change
    remove_column :questions, :like_count, :integer, default: 0
  end
end
