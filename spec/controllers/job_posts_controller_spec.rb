require 'rails_helper'


# Will have access to global variables and methods from the controller
# The session, the flash
# We also get methods named after the http verbs to simulate requests to the controller.
# All this access comes from RSpec.describe JobPostsController, type: :controller

RSpec.describe JobPostsController, type: :controller do
  def current_user
    # ||= conditional assignment
    @current_user ||= FactoryBot.create(:user)
  end

  def job_post
    @job_post ||= FactoryBot.create(:job_post)
  end

  def job_post_of_current_user
    # We make FactoryBot generate a job post with the user always the current user.
    @job_post ||= FactoryBot.create(:job_post, user: current_user)
  end

  

  describe "#new" do
  
    context "without user signed in" do
      it "redirects to the sign in page" do
        # Simulates a GET to /job_posts/new
        get(:new)

        expect(response).to redirect_to(new_sessions_path)
      end

      it "sets a danger flash" do
        get(:new)

        expect(flash[:danger]).to be
      end
    end

    context "with user signed in" do 

      # Use `before` to runa  block of code before all tests inside a scope. In this case, the following block will run before the two tests inside of this context's block.
      before do
        # To simulate signing in a user, set a `user_id` in the
        # session. Like the `flash`, the `session` is available
        # in controller testing.
        session[:user_id] = FactoryBot.create(:user).id
      end


      it "renders a new template" do
        # Given: Defaults
        
        # When: Making a GET request to the new action
        get(:new) # This method will simulate a GET request to the `new` action of the JobPostsController
        
        # Then: We expect the `response` will have rendered the new template.
        
        # There is a response object, just like in Node.
        
        expect(response).to(render_template(:new))
      end
      it "sets an instance variable with a new job post" do
        get(:new)
          # assigns(:job_post)
          # Returns the value of an instance variable named @job_post.
          # It returns 'nil' if it doesn't exist.
          expect(assigns(:job_post)).to(be_a_new(JobPost))
          # The above matcher will check that the expect value (assigns(:job_post)) is a new instance of the JobPost class.
          
      end
    end
  end
  
  describe "#create" do
  
  # context is functionally the same to `describe`, but we usually use `context` to divide tests into separate branching code paths.
    def valid_request
      post(:create, params: { job_post: FactoryBot.attributes_for(:job_post) })

    end

    context "without signed in user" do
      it "redirects to the new session page" do

        # even with a valid request, it should first go through the before_action :authenticate_user! method.
        valid_request

        expect(response).to redirect_to(new_sessions_path)
      end
    end

    context "with signed in user" do
      
      # Use the current_user method, and grab the id from it.
      before do
        session[:user_id] = current_user.id
        
        # Not FactoryBot.create(:user).id
      end

      context "with valid parameters" do
        it "creates a new job in the db" do

          # This mimics form_for. All the attributes we create are nested inside the params hash, under the job_post key.
          count_before = JobPost.count
          valid_request
          count_after = JobPost.count
          expect(count_after).to eq(count_before + 1)

        end

        it "redirect to the show page of the job post" do
          valid_request

          job_post = JobPost.last
          expect(response).to(redirect_to(job_posts_path(job_post)))
        end

        it "sets a success flash" do
          valid_request
          expect(flash[:success]).to be
        end

        it "associates the job post with the current user" do
          valid_request

          expect(JobPost.last.user).to eq(current_user)
        end
      end

      context "with invalid parameters" do
        def invalid_request
          post(:create, 
            params: { job_post: FactoryBot.attributes_for(:job_post, title: nil) })
        end

        it "doesn't create a job post in the db" do
          count_before = JobPost.count
          invalid_request
          count_after = JobPost.count

          expect(count_after).to eq(count_before)
        end

        it "renders the new template" do
          invalid_request
          expect(response).to render_template(:new)
        end

        it "assigns the invalid job post as an instance var." do
          invalid_request

          # be_a verifies it's an instance of the JobPost class too. be_a_new checks for `newness` too.
          expect(assigns(:job_post)).to(be_a(JobPost))
          expect(assigns(:job_post)).to be_invalid

          # expect(assigns(:job_post).valid?).to be false
          # expect(assigns(:job_post).valid?).to eq(false)
        end

      end
    end
    
    
  end
  
  describe "#show" do
    it "renders the show template" do
      # Given: A Job Post in the db
      job_post = FactoryBot.create(:job_post)

      # When: A GET to /posts/:id
      get(:show, params: { id: job_post.id })

      # Then: The response renders the show template
      expect(response).to render_template(:show)
    end

    it "sets @job_post for the shown job_post" do
      # Given:
      
      job_post = FactoryBot.create(:job_post)

      get(:show, params: { id: job_post.id })
      
      # Then: It retrieves the job_post, and sets it to the instance variable.

      expect(assigns(:job_post)).to eq(job_post)
    end
  end

  describe "#destroy" do
    def valid_request
      delete(:destroy, params: { id: job_post.id })
    end


    context "without user signed in" do
      it "redirects user to the new session path" do
      # Given/When
        # We need a job post to delete.
        job_post = FactoryBot.create(:job_post)
        delete(:destroy, params: { id: job_post.id })

      # Then
      expect(response).to redirect_to(new_sessions_path)

      end

    end

    context "with user signed in" do
      def valid_request
        delete(:destroy, params: { id: job_post})

      end


      before do
        session[:user_id] = current_user.id
      end

      context "as owner" do
        it "removes a job post from the db" do
          job_post = FactoryBot.create(:job_post)
          delete(:destroy, params: { id: job_post.id })

          # Find_by Active Record query method acts like `where`, except it only retrieves the first one. 
          # It also allows you to search any column. 
            # You also return nil if it finds nothing.
          # With `find` you can only use the id, and if it finds nothing, it will return an error, instead of nil.
          
          # The following commented out would not work because job_post created a new user. And the current_user called at the very beginning does not match this.
          expect(JobPost.find_by(id: job_post.id)). to be(nil)

          expect(JobPost.find_by(id: job_post_of_current_user.id))
          .to(be(nil))
        end

        it "redirects to the job post index" do
          valid_request
          expect(response).to redirect_to(job_posts_path)
        end

        it "flashes a success"
      end

      context "as non-owner" do
        it "does not remove a job post from the db" do
          valid_request


          expect(JobPost.find_by(id: job_post.id)).to be_a(JobPost)

        end
        it "redirects to the job post" do
          valid_request

          expect(response).to redirect_to(job_post_path(job_post))
        end
        it "flashes a danger" do
          valid_request
          expect(flash[:danger]).to be
        end

      end
    end
  end

  describe "#update" do

    context "without signed in user" do
      it "redirects to the new session path" do
        patch(:update, params: { job_post: FactoryBot.attributes_for(:job_post)
        })

        expect(response).to redirect_to(new_sessions_path)
      end
    end

    context "with signed in user" do
      before do
        # session[:user_id] = FactoryBot.create(:user).id
        session[:user_id] = current_user.id
      end
      context "as owner" do
        
        before do
          job_post_of_current_user
        end

        context "with valid params" do
          it "persists changes on a job post" do
            
            # If you do the next commented-out line, you will create yet another job_post with a new user, when you already have a before block doing job_post_of_current_user.
            # job_post = FactoryBot.create(:job_post)

            patch(:update, params: {  id: job_post.id,
                                      job_post: {  
                                        title: "New title"
                                      }
                                    }
                  )

            expect(JobPost.find_by(id: job_post_of_current_user.id).title).to eq("New title")
          end

          it "redirects to the job post show page"

        end
      end
    end
  end
end
