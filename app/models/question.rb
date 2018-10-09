# this is the Question model class
# Rails uses meta programming to add attr_accessor to all associated table's columns
# in this those will be: id, title, body, view_count, created_at, updated_at
class Question < ApplicationRecord
  validates :title, presence: true,
  uniqueness: { message: 'must be unique!!' }

  validates :body, length: { minimum: 10 }

  # the line below will validate the uniqueness of title/body combination
  # so title doesn't have to be unique on its own and body doesn't have to be unique
  # on its own but the combination must be unqiue.
  # validates :title, uniqueness: { scope: :body }

  validates :view_count, numericality: { greater_than_or_equal_to: 0 }

  validate :no_monkey_in_title

  # `before_validation` is a lifecycle callback method that allows
  # respond to event during the life a model instance (e.g. being validated,
  # being created, being updated, etc)
  # All lifecycle callback methods take a symbol named after a method
  # and calls that method at the appropriate time.
  before_validation(:set_default_view_count)

  # For all available methods, go to:
  # https://guides.rubyonrails.org/active_record_callbacks.html#available-callbacks

  # Create a scope with a class method
  # https://guides.rubyonrails.org/active_record_querying.html#scopes
  scope(:recent, -> { order(created_at: :desc).limit(10) })

  # Scopes are such a commonly used feature that there's to
  # create them quicker. It takes a name and a lambda as a callback.
  # def self.recent
  #   order(created_at: :desc).limit(10)
  # end

  scope(:search, -> (query) { where("title ILIKE ? OR body ILIKE ?", "%#{query}%", "%#{query}%") })

  # def self.search(query)
  #   where("title ILIKE ? OR body ILIKE ?", "%#{query}%", "%#{query}%")
  # end

  private

  def set_default_view_count
    # If you are writing to an attribute accessor, you
    # must prefix with `self.` which do not have to do
    # if you're just reading it instead.
    # self.view_count = 0 if self.view_count.nil?
    # self.view_count = self.view_count || 0
    # 👇 is syntax sugar for 👆
    self.view_count ||= 0
    # The elusive or-equal will only assign to its left-hand side
    # if it is `nil`.
  end

  def no_monkey_in_title
    # to make a record invalid, we only need to attach an error to a particular
    # field (for instance title) which will make the record invalid
    if !title.nil? && title.downcase.include?('monkey')
      errors.add(:title, 'no monkeys allowd!')
    end
  end
end
