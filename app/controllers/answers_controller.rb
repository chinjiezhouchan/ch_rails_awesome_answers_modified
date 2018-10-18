class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

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
end
