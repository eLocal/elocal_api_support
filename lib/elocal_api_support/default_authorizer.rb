module ElocalApiSupport
  class Authorization::DefaultAuthorizer
    attr_reader :caller

    FAIL_MESSAGE = <<-EOL.strip
  No token could be found for ElocalApiSupport to use.  Please resolve this by either
    - Define a method required_token which provides a token to check
    - Set the configuration token in your config/application.rb by setting a value for config.elocal_api_support_token
    - Define a method authorizer return a custom Authorization object which responds to authorize(token)
    EOL

    def initialize(caller)
      @caller = caller
    end

    def authorize(token)
      find_required_token == token
    end

    def find_required_token
      if caller.respond_to?(:required_token, true)
        caller.send(:required_token)
      elsif Rails.application.config.elocal_api_support_token.present?
        Rails.application.config.elocal_api_support_token
      else
        fail FAIL_MESSAGE
      end
    end
  end
end
