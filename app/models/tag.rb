class Tag < ApplicationRecord

  has_many :taggings, dependent: :destroy
  has_many :questions, through: :taggings#,source: question

  before_validation :downcase_name

  validates :name, presence: true, uniqueness: true
  
  private
  
  def downcase_name
    
    self.name&.downcase!
  # & is the `Safe navigation operator`. We only will execute the downcase method if we start with value that's not nil. If nil, it just returns nil.
  end
end
