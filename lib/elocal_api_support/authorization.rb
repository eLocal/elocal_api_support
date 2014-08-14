module ElocalApiSupport::Authorization
  extend ActiveSupport::Concern
  included do
    before_filter :authorize!
  end

  protected

  def find_required_token
    if respond_to?(:required_token, true)
      send(:required_token)
    elsif Rails.application.config.elocal_api_support_token.present?
      Rails.application.config.elocal_api_support_token
    else
      fail <<-EOL.strip
No token could be found for ElocalApiSupport to use.  Please define a method required_token or set the
configuration token in your config/application.rb by setting a value for config.elocal_api_support_token
      EOL
    end
  end

  def authorized?
    authorize_request_token == find_required_token
  end

  def error_response_hash
    {error: "You are not an authorized user!"}.to_json
  end

  def authorize!
    unless authorized?
      logger.warn("Somebody else tried to access our internal API!  Value: #{authorize_request_token} Params: #{params}, Headers: #{request.headers.map{|k,v| k}}")
      render json: error_response_hash, status: 401
    end
  end

  def authorize_request_token
    [params[:request_token], request.headers["HTTP_X_REQUEST_TOKEN"]].detect(&:present?)
  end
end
