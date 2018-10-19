class QuestionsController < ApplicationController
  # Public methods in controller classes are
  # are often named "actions". An action
  # creates the response to send back to
  # the client (i.e browser).

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def new
    @question = Question.new
    # res.send({ a: 1 })
    # render plain: "questions#new"
  end

  def create
    # res.send(req.body)
    # The `params` object is availabe in controllers. It contains
    # the form's data, url params and query params.
    # To compare with Express, it's a combination of
    # req.body, req.query and req.params.
    # render json: question_params

    @question = Question.new question_params
    @question.user = current_user

    if @question.save
      redirect_to question_path(@question.id)
    else
      render :new
    end
  end

  def index
    # Instance variables (e.g @questions) in actions can be
    # used in the templates that are rendered by the action.
    # Example: We can use @question inside of the
    # questions index template.
    @questions = Question.all.order(created_at: :desc)
  end

  def show
    @answers = @question.answers.order(created_at: :desc)
    @answer = Answer.new

    # @question.view_count += 1
    # @question.save

    # Use `update_columns` SPARINGLY. It's an alternative
    # to `update` that will skip validations, lifecycle callbacks
    # updating the `updated_at` column. It directly does the
    # update on the db while skipping the normal active record
    # steps.

    @question.update_columns(
      view_count: @question.view_count + 1
    )
  end

  def destroy
    @question.destroy

    redirect_to questions_path
  end

  def edit
  end

  def update
    if @question.update question_params
      redirect_to question_path(@question.id)
    else
      render :edit
    end
  end

  private
  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find params[:id]
  end

  def authorize_user!
    # We add a ! to the name of this method as convention, because it can
    # mutate the `response` object of our controller.
    unless can? :crud, @question
      flash[:alert] = "Access Denied"
      redirect_to home_path
    end
  end
end
