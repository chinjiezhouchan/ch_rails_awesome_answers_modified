class WelcomeController < ApplicationController

  def index
    # by Convention: Rails will attempt to render a template inside the views folder
    # within a subfolder that matches the controller name (in this case `welcome`)
    # using a template that matches the actions name (in this case `index`), the defult
    # extension will be `.html.erb`
    # this will be: app/views/welcome/index.html.erb

    # render plain: 'Hello World'
  end

  def home

  end
end
