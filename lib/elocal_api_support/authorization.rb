module ElocalApiSupport::Authorization
  extend ActiveSupport::Concern

  included do
    before_filter :authorize!
  end

  protected

  def authorized?
    find_authorizer.authorize(authorize_request_token)
  end

  def find_authorizer
    if respond_to?(:authorizer, true)
      send(:authorizer)
    else
      DefaultAuthorizer.new(self)
    end
  end

  def error_response_hash
    { error: 'You are not an authorized user!' }.to_json
  end

  def authorize!
    return if authorized?

    Rails.logger.warn(
      format(
        'Somebody else tried to access our internal API!  Value: %s Params: %s, Headers: %s',
        authorize_request_token,
        params,
        request.headers.map { |k, _v| k }
      )
    )
    render json: error_response_hash, status: 401
  end

  def authorize_request_token
    [params[:request_token], request.headers['HTTP_X_REQUEST_TOKEN']].detect(&:present?)
  end
end
