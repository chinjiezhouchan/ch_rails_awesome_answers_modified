class Tagging < ApplicationRecord
  belongs_to :question
  belongs_to :tag


  # It rarely makes sense to have duplicate tags from the same user? So we will validate the uniqueness of the combo of user and question.

  validates(:tag_id, uniqueness: {
    scope: :question_id
  })
end
