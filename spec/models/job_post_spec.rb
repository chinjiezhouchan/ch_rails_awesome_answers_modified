require 'rails_helper'

# To run all of your tests, use the following command:
# `rspec`

RSpec.describe JobPost, type: :model do
  it("requires a title") do
    # GIVEN: An instance of a JobPost
    job_post = JobPost.new

    # WHEN: Validations are triggered?
    job_post.valid?

    # THEN: There's a title related error in the instance
    
    # The `expect` takes the value that we're testing.

    # In Rspec, we verify our expected values with matchers.
    # In the below, we are testing that `job_post.errors.messages`
    # has named `:title`.
    expect(job_post.errors.messages).to(have_key(:title))

    # For a list of matchers, go to:
    # https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
  end

  it "requires that min_salary is a number" do
    job_post = JobPost.new

    job_post.valid?

    expect(job_post.errors.messages).to have_key(:min_salary)
  end

  it "requires that min_salary is greater than 20_000" do
    job_post = JobPost.new min_salary: 19_999

    job_post.valid?

    expect(job_post.errors.messages).to have_key(:min_salary)
    expect(job_post.errors.messages[:min_salary])
      .to(eq(["must be greater than 20000"]))
  end
end
