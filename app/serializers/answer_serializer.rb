class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  # key: lets you change the name of `user` to `author` when you send it as JSON
  belongs_to :user, key: :author
  belongs_to :question
end
