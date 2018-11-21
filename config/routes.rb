Rails.application.routes.draw do
  
  match(
    "/delayed_job",
    to: DelayedJobWeb,
    anchor: false,
    via: [:get, :post]
  )
  
  resources :job_posts, only: [:new, :create, :show, :destroy, :update]

  # GET -> /api/v1/questions -> Api::V1::QuestionsController / index action
  # get '/api/v1/questions', { to: 'api/v1/questions#index' }
  # The following matches "folder/folder/controller" like our API itself
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :questions, only: [:index, :show, :create, :delete]

      # If we instead did `resources`, our destroy route would take an id. But for sessions, we don't need an id, we just need to nullify the session.
      resource :sessions, only: [:create, :destroy]
      resources :users, only: [] do
        # A custom route inside users.
        # On collection means the action is on the entire collection of users.
        # /api/v1/users/current
        get :current, on: :collection
        # /api/v1/users/:question_id/current <- default
        # /api/v1/users/:id/current <- on: :member
      end
    end
  end

  # post(
  #   "/questions/:question_id/answers",
  #   to: "answers#create",
  #   as: :question_answers
  # )
    
  # Question Related Routes
  resources :questions do
    # Routes nested in a resource will get
    # prefixed with the resources path and its
    # URL param for its `id` (e.g. /questions/:question_id)
    
    # /questions/liked
    # You don't want /questions/:question_id/liked because this implies you're still looking up a single question, instead of getting all questions you liked.

    # Use the "on" named argument to specify how a nested route behaves relative to its parent.

    # `on: :collection` means that it acts on the entire
    # resource. All questions in this case. `new` & `create`
    # act on the collection.

    # `on: :member` means that it acts on a single
    # resource. A single question this case. `edit`, `destroy`,
    # `show` and `update` are all member routes.

    # option: on: :member, or on: :collection. Collection should make the :question_id disappear.

  
    get(:liked, on: :collection)

    resources :answers, only: [ :create, :destroy ]
    resources :likes, shallow: true, only: [:create, :destroy]
      # The `shallow: true` named argument will separate routes that require the parent from those that don't.
      # Routes that require the parent will not change, e.g. new, index, create.
      # Rails will take the parent prefix off routes that don't need it, e.g. show, edit, update, destroy.
      
      # Example:
      # /questions/10/likes/9/edit becomes /likes/9/edit 
  end
  # `resources` will generate all CRUD routes for a specified
  # name (e.g. questions). It assumes that there's controller with
  # a similar name that's pluralized (e.g. QuestionsController).

  # get("/questions/new", to: "questions#new", as: :new_question)
  # post("/questions", to: "questions#create", as: :questions)
  # get("/questions", to: "questions#index")
  # get("/questions/:id", to: "questions#show", as: :question)
  # delete("/questions/:id", to: "questions#destroy")
  # get("/questions/:id/edit", to: "questions#edit", as: :edit_question)
  # patch("/questions/:id", to: "questions#update")

  # this defined a routing rule that says: if I recevie an HTTP / GET request
  # to URL: `/hello_world` then handle this with the `WelcomeContrller` using the `index`
  # method (called action, methods inside controller are called actions)
  get('/hello_world', { to: 'welcome#index', as: :hello_world })

  resources :users, only: [:new, :create]
  resource :sessions, only: [:new, :create, :destroy]

  # the `as` option gives a special name to the URL so we can easily generate
  # it in our view and controller files, to generate url we use the name we chose
  # here after adding `_path` or `_url` to it (for relative or absolute path)
  get('/', { to: 'welcome#home', as: :home })

  root({ to: 'welcome#home' })
end
