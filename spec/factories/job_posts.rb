  # - FactoryBot.build(:job_post) <- returns the instance
  #   of a JobPost that hasn't been persisted
  # - FactoryBot.create(:job_post) <- returns the instance
  #   of a JobPost that has been persisted
  # - FactoryBot.attributes_for(:job_post) <- returns
  #   a plain ruby hash containing all parameters to create
  #   a JobPost instance. Very useful in controller testing.

FactoryBot.define do
  factory :job_post do

    # The line below will create a user before creating a job post which will be associated to it.
    # The named argument `factory` specifies which factory should be used to create the associated model instance.
    association(:user, factory: :user)

    # If using Faker, always pass it in as a block {}, this makes it call Faker each and every generation.
    title { Faker::Job.title }
    description { Faker::Job.field }
    min_salary { rand(20_001.. 100_000) }
    max_salary { rand(60_000.. 140_000) }
  end
end
