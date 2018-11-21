class User < ApplicationRecord
  has_many :job_posts, dependent: :nullify
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  
  
  has_many :likes, dependent: :destroy
  # The `has_many :liked_questions` below depends on the existence of the
  # `has_many :likes` above. If the one above doesn't exist,
  # you will get an error. If the one above comes after the
  # `has_many` below, you will also get an error.


  # You need to define has_many :likes first for the following to work.
  # has_many can take a `through` named argument that takes the name of another has_many association
  # has_many <association-name>

  # When doing so, we need to specify the name of the model we're getting back from the relationship. In this case, it's the question. In this case, it's the # question. Use the `source` named argument to do so.
  has_many :liked_questions, through: :likes, source: :question

  
  # has_secure_password is built-in with rails and it adds password hashing feature
  # to your model.
  # it automatically adds attribute accessors for password and password_confirmation
  # it will automatically add presence validation for password
  # if `password_confirmation` is given, it will make sure it matched `password`
  # Also, it will generate a random salt and then hash the given password with the salt
  # then it will store the combo of salt/hashed_password in the `password_digerst` field
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :first_name, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: VALID_EMAIL_REGEX

  def full_name
    "#{first_name} #{last_name}".strip
  end

end
