class Api::V1::QuestionsController < Api::ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  def index
    questions = Question.order(created_at: :desc)
    render json: questions
  end

  def show
    # question = Question.find params[:id]
    render json: question
  end

  def destroy
    # question = Question.find params[:id]
    question.destroy
    render json: { status: :success }
  end

  def create
    question = Question.new question_params
    question.user = current_user
    if question.save
      render json: question
    else
      render json: { errors: question.errors.full_messages }
    end
  end

  private

  def question_params
    # I must have a key called `question` as part of my params.
    # From `question`, I will permit title and body.
    params.require(:question).permit(:title, :body)
  end

  def question
    Question.find params[:id]
  end

end
