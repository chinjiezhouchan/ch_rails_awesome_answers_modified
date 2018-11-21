# this is the Question model class
# Rails uses meta programming to add attr_accessor to all associated table's columns
# in this those will be: id, title, body, view_count, created_at, updated_at
class Question < ApplicationRecord
  belongs_to :user

  # So, 1) Ask yourself which end of the many-to-many this is. -> Questions.  Many Questions have many Tags.
  # 2) First define the join table in the middle.
  has_many :taggings, dependent: :destroy
  # You can omit `,source: tag` if your resource name is the plural of the source model name. 
  # You only need to specify it if you named your resource different, e.g. likers vs users.
  has_many :tags, through: :taggings#, source: :tag
  
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  # When deleting the instance of a model with associated rows (dependents),
  # the foreign key constraint will prevent it from being deleted. We can
  # tell active to first delete the dependents before the deleting the
  # model instance. This is what the `dependent: :destroy` argument does
  # with the `has_many` method.

  # Use `dependent: :nullify` to instead set the foreign key column to `NULL`
  # of the dependent instead of deleting.
  has_many :answers, dependent: :destroy

  # `has_many :answers` adds the following instance methods
  # to the Question model:

  # answers
  # answers<<(object, ...)
  # answers.delete(object, ...)
  # answers.destroy(object, ...)
  # answers=(objects)
  # answer_ids
  # answer_ids=(ids)
  # answers.clear
  # answers.empty?
  # answers.size
  # answers.find(...)
  # answers.where(...)
  # answers.exists?(...)
  # answers.build(attributes = {}, ...)
  # answers.create(attributes = {})
  # answers.create!(attributes = {})
  # answers.reload

  # Association instance methods can be used as part
  # of an Active Record query chain, for example:
  # q.answers.where("id > ?", 1).order(body: :desc).first

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

  # This is a virtual column. It does not acutally exist in the table, but it's as if it does.
  # form_for in the views is looking for the method. It doesn't have to be a column. Because Rails' ActiveRecord normally makes methods for each of the columns - attribute accessors.
  def tag_names
    # This gets the array.
    self.tags.map{ |t| t.name }.join(",")
  end


  # Appending = at the end of a method name, allows you to implement a "setter". A setter is a method that is assignable.
  # a = 1
  # q.tag_names = "stuff,yo"


  # This is like implementing an attribute writer, but we want it to do more than an attr_writer. We want this to add the tags to the Tags database.
  def tag_names=(rhs)

    # Assign to the tags of the model instance (an individual product) all the tags we find, when we query the database with the names of all the tags.
    self.tags = rhs.strip.split(/\s*,\s*/).map do | tag_name|
      Tag.find_or_initialize_by(name: tag_name)
    end
  end

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
