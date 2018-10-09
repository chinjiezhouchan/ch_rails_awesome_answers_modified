Rails.application.routes.draw do
  # this defined a routing rule that says: if I recevie an HTTP / GET request
  # to URL: `/hello_world` then handle this with the `WelcomeContrller` using the `index`
  # method (called action, methods inside controller are called actions)
  get('/hello_world', { to: 'welcome#index', as: :hello_world })
  
  # the `as` option gives a special name to the URL so we can easily generate
  # it in our view and controller files, to generate url we use the name we chose
  # here after adding `_path` or `_url` to it (for relative or absolute path)
  get('/', { to: 'welcome#home_page', as: :home_page })
end
