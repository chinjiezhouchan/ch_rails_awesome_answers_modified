class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :find_answer, only: [:destroy]
  before_action :authorize_user!, only: [:destroy]

  def create
    @question = Question.find params[:question_id]
    @answer = Answer.new answer_params
    # @question << @answer
    @answer.question = @question
    @answer.user = current_user

    if @answer.save

      # Say we want to notify the question.user that someone answered them:
      if @question.user.present?
        # AnswerMailer
        #   .notify_question_owner(@answer)
        #   .deliver

        AnswerMailer
          .notify_question_owner(@answer)
          .deliver_later
            # Using `deliver_later` instead of `deliver` will send the main asynchronously using ActiveJob.
            # This means a row will be added for this mail in the delayed_job queue table. As soon as a worker is ready, the mail will be sent. 
      end

      redirect_to question_path(@question)
    else
      @answers = @question.answers.order(created_at: :desc)
      render "questions/show"
    end
  end

  def destroy
 
    @answer = Answer.find params[:id]
    @answer.destroy

    # https://api.rubyonrails.org/classes/ActionController/Redirecting.html
    # If you are using XHR requests other than GET or POST and redirecting after
    # the request then some browsers will follow the redirect using the original
    # request method. This may lead to undesirable behavior such as a double DELETE.
    # To work around this you can return a 303 See Other status code which
    # will be followed using a GET request.
    
    redirect_to(question_path(@answer.question.id), status: 303) # SEE OTHER
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_answer
    @answer = Answer.find params[:id]
  end

  def authorize_user!
    unless can? :crud, @answer
      flash[:danger] = "Access Denied"
      redirect_to home_path
    end
  end
end
