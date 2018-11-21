require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AwesomeAnswers
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      # Don't create helpers files when using
      # the generator
      g.helper = false
      # Don't create assets files when using the
      # generator
      g.assets = false

      # This tells Rails' ActiveJob to use the gem
      # "delayed_job" to manage our job queue.
      config.active_job.queue_adapter = :delayed_job

      config.middleware.insert_before(0, Rack::Cors) do 
        # Pass a block for configuring Rack-Cors -> These tell what conditions a CORS request must satisfy before the server allows it.
        allow do
          # origins specifies which hosts we allow to make CORS requests to our Rails server.
          # I'm serving my files, but the error was, "origins are null"
          origins "localhost:3030", "localhost:3001"
          resource(
            # First arg specifies that only those routes with /api/ will accept CORS requests. Not the regular routes /questions, but api/questions.
            "/api/*",
            # 
            headers: :any,
            credentials: true,
            # Third arg here is the HTTP methods the requests may use to get CORS requests.
            methods: [:get, :post, :delete, :patch, :put, :options]
          )
        end
      end
    end
  end
end
