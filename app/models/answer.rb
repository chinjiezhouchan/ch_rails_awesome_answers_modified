class Answer < ApplicationRecord
  # In an association between two tables, the model
  # that has the `belongs_to` method
  # is always the model that has the foreign key
  # column (i.e. question_id)

  # Rails guide on Associations
  # http://guides.rubyonrails.org/association_basics.html

  # By default, `belongs_to` will create a validation
  # such as `validates :question_id, presence: true`.
  # It can be disabled by passing the argument
  # `optional: true` to the `belongs_to` method.
  belongs_to :question#, optional: true

  # The following instance methods are added to
  # the Answer model by the line `belongs_to :question`:

  # question
  # question=(associate)
  # build_question(attributes = {})
  # create_question(attributes = {})
  # create_question!(attributes = {})
  # reload_question

  # Methods that save instances of a model that end with
  # `!` (e.g. save!, create_question!) raise an error
  # when a validation fails. Methods without a `!` return
  # `false` on a validation failure.

  validates :body, presence: true
end
