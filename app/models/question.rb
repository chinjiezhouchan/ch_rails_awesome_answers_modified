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
  
  private 

  def no_monkey_in_title
    # to make a record invalid, we only need to attach an error to a particular
    # field (for instance title) which will make the record invalid
    if !title.nil? && title.downcase.include?('monkey')
      errors.add(:title, 'no monkeys allowd!')
    end
  end
end
