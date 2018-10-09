# Cleaning up existing data
Question.destroy_all

NUM_OF_QUESTIONS = 1000


NUM_OF_QUESTIONS.times do
  Question.create title: Faker::Simpsons.quote,
                  body: Faker::Hacker.say_something_smart,
                  view_count: rand(1000)
end

puts Cowsay.say("Generated #{Question.count} questions", :cow)
