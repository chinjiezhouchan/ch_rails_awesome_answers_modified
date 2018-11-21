class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :view_count, :created_at

  has_many :answers
  belongs_to :user, key: :author

  def created_at
    # `object` refers to the object (in this case Question) being serialized
    # This is a Ruby method that
    object.created_at.strftime('%Y-%B-%d')

  end

end


