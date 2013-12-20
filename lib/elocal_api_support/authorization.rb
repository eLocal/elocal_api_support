module ElocalApiSupport::Authorization
  extend ActiveSupport::Concern
  included do
    before_filter :authorize!
  end

  protected

  def required_token
    raise 'Please implement the required token method'
  end

  def authorized?
    authorize_request_token == required_token
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
