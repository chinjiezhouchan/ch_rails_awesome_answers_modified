FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| Faker::Internet.email.sub("@", ".#{n}@") }
    password { "supersecret" }

    # Steve thinks it's stored in memory, how many iterations.

    # So if you exit rails console, it's probably gone.

    # But during a test, that's probably okay as the database gets wiped out anyway after a test.
  end
end
