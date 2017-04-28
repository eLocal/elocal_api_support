class FakesController < ActionController::Base
  include Rails.application.routes.url_helpers

  def index
    head :accepted
  end
end
