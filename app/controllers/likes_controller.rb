class LikesController < ApplicationController

  before_action :authenticate_user!

  # Not before destroy too because the url won't have the :question_id in it.
  before_action :find_question, only: [ :create ]
  before_action :authorize_user!, only: [ :create ]

  def create
    question = Question.find(params[:question_id])
    like = Like.new(user: current_user, question: question)

    if like.save
      flash[:success] = "Question liked"
    else
      flash[:danger] = like.errors.full_messages.join(", ")
    end

    redirect_to question_path(question)
  end

  def destroy
    like = Like.find params[:id]
    like.destroy

    flash[:success] = "Question unliked"
    redirect_to question_path(like.question)
  end

  private
  def find_question
    @question = Question.find params[:question_id]
  end

  def authorize_user!
    unless can?(:like, @question)
      flash[:danger] = "Don't be a narcissist"
      redirect_to question_path(@question)
    end
  end
end
