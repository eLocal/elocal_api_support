module ElocalApiSupport::EnableCors
  extend ActiveSupport::Concern
  included do
    cors_allow_all
    before_action :enable_cors
  end

  module ClassMethods
    attr_accessor :cors_allow_origin, :cors_allow_methods, :cors_allow_headers
    def cors_allow_all
      self.cors_allow_origin  = '*'
      self.cors_allow_methods = %w(GET POST PUT DELETE).join(',')
      self.cors_allow_headers = %w(Origin Accept Content-Type X-Requested-With X-XSRF-Token).join(',')
    end
  end

  def enable_cors
    response.headers['Access-Control-Allow-Origin']  = self.class.cors_allow_origin
    response.headers['Access-Control-Allow-Methods'] = self.class.cors_allow_methods
    response.headers['Access-Control-Allow-Headers'] = self.class.cors_allow_headers
    head(:ok) if request.request_method == 'OPTIONS'
  end
end
