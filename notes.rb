rails g controller questions

rails routes


# form_for is a Rails helper.

# Shift-Ctrl-F

# Question.last


# <%= render "form"%>


# Rails One To Many


# If new model needed:
rails g model answer body:text question:references
rails db:migrate

# If model already exists, and you are changing it:
# "Question references User"
rails g migration add_user_references_to_question user:references





a.question_id = q.question_id
a.save

a.question = Question.first

# After adding has_many :answers to Model class Question
reload!

q = Question.all.sample

q.answers
# Returns the answers associated with the question instance in q.
# Can start a query as well. 
q.answers.where("id > 1")

q.answers = 
# Associates answers to the question instance in q.


q.answers_ids

q.answers_ids = [1,2]
# Makes answers with id 1 and 2 associated with Question q. Before, 3 and 4 also were associated.

Answer.last(2)

# These don't have a question_id

q.answers = Answer.last(2)

q.answers << Answer.new(body:"Smart knowledge and wisdom")

# In Rails console
app.question_answer_path(1,2)
# Leads to "/questions/1/answers/2"


# AUTHENTICATION

database.yml

# Still have to create a database with the same name. Can use rails db:create, or psql, or any method.

# Create users in our system. 
# Users will be models.

# Sample use of SHA1 Digest. Ruby comes with it.

pry

require 'digest'
Digest::SHA1
Digest::SHA1.digest('String to digest')

rails g model user first_name last_name email password_digest
# Rails convention: Name the hashed password column password_digest

# In Gemfile, comment back in 
gem 'bcrypt', '~> 3.1.7'

u = User.new(first_name: 'tam', email: 'tam@codecore.ca', password: 'supersecret')

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i


# Making a sign-in page.

# 1. Ask for routes.


u = User.find_by_email 

u.authenticate 'password_try'

rails g migration add_user_references_to_questions  user:references



# RAILS AUTHORIZATION


# Add gem 'cancancan', '~> 2.0' to Gemfile

bundle install

rails g cancan:ability

rails g migration add_admin_to_users admin:boolean


# HEROKU

heroku create project-name-with-lowercase-dash-only

git push heroku master

heroku run rails db:migrate



# Test Driven Development

gem install minitest













# FACTORY BOT

gem 'factory_bot_rails'

gem 'rails-controller-testing'

rails g --help

rails g factory_bot:model job_post

# attributes_for gives you a hash that is not an instance, but YOU CAN USE IT FOR PARAMS
# Give it the model name. Not the pluralized database name.

FactoryBot.attributes_for(:job_post)


  # - FactoryBot.build(:job_post) <- returns the instance
  #   of a JobPost that hasn't been persisted
  # - FactoryBot.create(:job_post) <- returns the instance
  #   of a JobPost that has been persisted
  # - FactoryBot.attributes_for(:job_post) <- returns
  #   a plain ruby hash containing all parameters to create
  #   a JobPost instance. Very useful in controller testing.


# .build is equivalent to .new
FactoryBot.build(:job_post)
FactoryBot.create(:job_post)

# This will make one column always one value.
FactoryBot.attributes_for(:job_post, title: "Software Engineer")

FactoryBot.attributes_for(:job_post, title: nil)


# CONTROLLER TESTING


# MANY TO MANY RELATIONSHIP

rails g model like user:references question:references 

rails db:migrate

l = Like.new(user: User.all.sample, question: Question.all.sample)

u = l.user

u.liked_questions

# In user Model

has_many :likes, dependent: :destroy

has_many :liked_questions, through: :likes, source: :question

# In Question Model

has_many :likes, dependent: :destroy
has_many :likers, through: :likes, source: :user

# This inserts into the Likes table, as you can see in the SQL query if you use it in the console.
u.liked_questions << Question.all.sample

q.likers << User.all.sample
# Possible for the same user to like a question more than once -> need a validation.

# For each combo of one user and one question, there should be a single like.

# Testing Validations
# It helps to save it in a variable so you can call methods like .valid? and .errors.full_messages

POST /questions/:question_id/likes
DELETE /questions/:question_id/

l = Like.new(user_id: 11, question_id: 28)

l.valid?

l.errors.full_messages

<small>
<%= link_to("Like", question_likes_path(@question), method: :post) %>
</small>

rails g controller likes


q.likes.find_by(user: User.find(13))

# Pluralize is a helper for the views file that prints the count, and the word you specify with an "s" or other pluralization when appropriate
pluralize(@question.likes.count, "like")



# In the ability.rb rile

can(:like, Question) do |question|
  user.persisted? && user != question.user
end


rails g resource like review:references user:references



# MORE ON MANY TO MANY


rails g model tag name:string

rails g model tagging question:references tag:references


# Rails does not like the following because there is no column "tag_names" in the question model. 

# <%= form.text_field :tag_names, class: "form-control" %> 

.split(/,\s*/)
# `\s` represents whitespace characters
# * after anything means 1 or more of that thing
# /.../ is a regex expression
# so ,\s* would be comma, 1 or more whitespace characters.

.split()

Tag.find_or_create_by(name: "coding")

Tag.find_or_initialize_by(name: "coding")

a = ["coding", "ruby"]
q = Question.first

q.tags << 

# For Selectize
<script>
  $("#question_tag_names").selectize({
    delimiter: ',',
    persist: false,
    # labelField: is how it will be displayed, e.g. the little pill
    # valueField: is how we will send it to Rails. If we inspect it, the comma-separated string of our tag names.
    # searchField: I think it's what field it performs a search through as you type.
    
    options: <%= Tag.select(:name).to_json(except: [:id]).html_safe %>>
    # html_safe stops it from escaping the quotes.
    create: function(input) {
        return {
            value: input,
            text: input
        }
    }
});
</script>


Tag.all.to_json

Tag.select(:name).to_json

# Put this in Selectize's Options.
# This makes .selectize
<%= Tag.select(:name).to_json(except: [:id]).html_safe %>>

# MAILERS AND DELAYED JOBS

rails g mailer

AnswerMailer.notify_question_owner()

# Place this in config/environments/development.rb



# Don't care if the mailer can't send.

# The following setting must be to `true` otherwise
# all your mail will fail silently. If you mail is not properly
# with Google and it raises error, you will not know about it
# unless this setting is set to `true`.
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :letter_opener
config.action_mailer.perform_deliveries = true
config.action_mailer.default_url_options = {
  host: "localhost:3000"
}



#

rails g delayed_job:active_record

# Jobs are very 

rails g job hello_world

# Delayed Jobs: 

# perform_now runs synchronously as the page loads.
HelloWorldJob.perform_now

# .perform_later inserts the job into the delayed_job queue table
HelloWorldJob.perform_later

# This performs the delayed jobs
rails jobs:work

HelloWorldJob.set(wait: 10.seconds).perform_later

HelloWorldJob.set(run_at: 1.day.from_now).perform_later("This passes the arguments into the perform method")