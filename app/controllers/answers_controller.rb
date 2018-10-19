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
      redirect_to question_path(@question)
    else
      @answers = @question.answers.order(created_at: :desc)
      render "questions/show"
    end
  end

  def destroy
    @answer = Answer.find params[:id]
    @answer.destroy

    redirect_to question_path(@answer.question.id)
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
      flash[:alert] = "Access Denied"
      redirect_to home_path
    end
  end
end
