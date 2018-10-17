# Cleaning up existing data
Answer.delete_all
Question.delete_all
# DELETE FROM questions;

NUM_OF_QUESTIONS = 100


NUM_OF_QUESTIONS.times do
  q = Question.create(
    title: Faker::Hacker.say_something_smart,
    body: Faker::Simpsons.quote,
    view_count: rand(1000)
  )

  if q.valid?
    rand(0..15).times do
      q.answers\ << Answer.new(
        body: Faker::GreekPhilosophers.quote
      )
    end
  end
end

answers = Answer.all

puts Cowsay.say("Generated #{Question.count} questions", :cow)
puts Cowsay.say("Generated #{answers.count} answers", :frogs)
