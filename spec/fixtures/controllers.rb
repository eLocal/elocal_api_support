class FakesController < ActionController::Base
  respond_to :json
  include Rails.application.routes.url_helpers

  def index
    render nothing: true
  end
end
