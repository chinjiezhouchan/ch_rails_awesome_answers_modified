class Like < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates(
    :question_id,
    uniqueness: {
      scope: :user_id,
      message: "has already been liked"
    })
  # "Question Id only has to be unique, when the user_id is the same."
  # When we have the same user_id, question_id needs to be unique.

  # id | question_id | user_id
  # 1  | 20          | 3   -> Valid
  # 2  | 13          | 9   -> Valid
  # 3  | 33          | 3   -> Valid 
  # 4  | 33          | 11  -> Valid 
  # 3  | 33          | 11  -> Invalid 
  # 3  | 20          | 3   -> Invalid 
end
