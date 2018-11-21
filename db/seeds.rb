# Cleaning up existing data
Tagging.delete_all
Tag.delete_all
JobPost.delete_all
Like.delete_all
Answer.delete_all
Question.delete_all
User.delete_all
# DELETE FROM questions;

PASSWORD = "supersecret"
NUM_OF_QUESTIONS = 20

super_user = User.create(
  first_name: "Jon",
  last_name: "Snow",
  email: "js@winterfell.gov",
  password: PASSWORD,
  admin: true
)

10.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  u = User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name.downcase}.#{last_name.downcase}@example.com",
    password: PASSWORD
  )
end

users = User.all
puts Cowsay.say("Generated #{users.count} users", :sheep)

20.times do
  Tag.create(
    name: Faker::Book.genre
  )
end

tags = Tag.all

NUM_OF_QUESTIONS.times do
  q = Question.create(
    title: Faker::Hacker.say_something_smart,
    body: Faker::Simpsons.quote,
    view_count: rand(1000),
    user: users.sample
  )

  # You can assign an array-like object of a bunch of models 
  q.likers = users.shuffle.slice(0, rand(users.count))

  q.tags = tags.shuffle.slice(0, rand(tags.count / 2))

  if q.valid?
    rand(0..8).times do
      q.answers << Answer.new(
        body: Faker::GreekPhilosophers.quote,
        user: users.sample
      )
    end
  end
end

answers = Answer.all

puts Cowsay.say("Generated #{Question.count} questions", :cow)
puts Cowsay.say("Generated #{answers.count} answers", :frogs)
puts "Login with #{super_user.email} and password of '#{PASSWORD}'"