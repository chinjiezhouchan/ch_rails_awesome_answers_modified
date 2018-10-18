class User < ApplicationRecord
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
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
