require 'rails_helper'

# To run all of your tests, use the following command:
# `rspec`

# You can provide the format option with the documentation to output detailed test information when running rspec as follows:
# `rspec -f d`

# When running rspec, you can choose to run tests in a single file by providing the path to the file as an argument to the command:
# rspec spec/models/job_post_spec.rb

# You can also run a single test inside a file by appending the line number of the test after the path/filename.
# rspec spec/models/job_post_spec.rb:13

# The above works on both single tests, and describe/context groups of tests.

# There is a plugin that

RSpec.describe JobPost, type: :model do
  describe("validations") do
    it("requires a title") do
      # GIVEN: An instance of a JobPost
      job_post = FactoryBot.build(:job_post, title: nil)

      # WHEN: Validations are triggered?
      job_post.valid?

      # THEN: There's a title related error in the instance
      
      # The `expect` takes the value that we're testing.

      # In Rspec, we verify our expected values with matchers.
      # In the below, we are testing that `job_post.errors.messages`
      # has a key named `:title`.
      expect(job_post.errors.messages).to(have_key(:title))

      # For a list of matchers, go to:
      # https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end

    it "requires that min_salary is a number" do
      job_post = FactoryBot.build(:job_post, min_salary: "Not a Number")

      job_post.valid?

      expect(job_post.errors.messages).to have_key(:min_salary)
    end

    it "requires that min_salary is greater than 20_000" do
      job_post = FactoryBot.build(min_salary: 19_999)

      job_post.valid?

      expect(job_post.errors.messages).to have_key(:min_salary)
      expect(job_post.errors.messages[:min_salary])
        .to(eq(["must be greater than 20000"]))
    end
  end

  # When describing a method name, :: prefixing the name means it's a class method. A # prefixing the name means it's an instance method.
  describe "::search" do
    # JobPost.search("Software")
    it "returns 2 job posts" do
      # Given: 3 JobPosts in my DB
      j1 = JobPost.create(:job_post, 
        title: "Software Developer"
      )
      j2 = JobPost.create(:job_post,
      title: "Software Artist"
      )
      j3 = JobPost.create(:job_post, title:"Programmer"    
      )

      # When: A search for "Software"
      results = JobPost.search("Software")
      # The results will not be an array per se, but an array-like object called "Active..something" that you can treat like an array.

      # Then: JobPost A & B are returned
      expect(results).to eq([j1,j2])

    end
  end

end
