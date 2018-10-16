class QuestionsController < ApplicationController
  # Public methods in controller classes are
  # are often named "actions". An action
  # creates the response to send back to
  # the client (i.e browser).

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
    @question = Question.find params[:id]
    @question.view_count += 1
    @question.save
  end

  def destroy
    @question = Question.find params[:id]
    @question.destroy

    redirect_to questions_path
  end

  def edit
    @question = Question.find params[:id]
  end

  def update
    @question = Question.find params[:id]

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
end
