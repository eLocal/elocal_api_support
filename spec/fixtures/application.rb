require 'active_support/all'
require 'action_controller'
require 'action_dispatch'

module Rails
  class App
    def env_config
      {}
    end

    def config
      OpenStruct.new
    end

    def routes
      return @routes if defined?(@routes)
      @routes = ActionDispatch::Routing::RouteSet.new
      @routes.draw do
        resources :auth
      end
      @routes
    end

    def logger
      @logger ||= begin
        Dir.mkdir('log') unless Dir.exist?('log')
        Logger.new('log/test.log')
      end
    end
  end

  def self.logger
    application.logger
  end

  def self.application
    @app ||= App.new
  end
end
