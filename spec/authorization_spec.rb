require 'spec_helper'

class AuthController < FakesController
  include ElocalApiSupport::Authorization

  protected

  def required_token
    'mysecretkey'
  end
end

class FakeAuthorizer
  def authorize(token)
    token == 'FakeAuthorizerKey'
  end
end

describe AuthController, type: :controller do
  let(:error_response) { { 'error' => 'You are not an authorized user!' }.to_json }

  describe 'With Default Authorizer' do
    it 'uses default authorizer' do
      expect(controller.send(:find_authorizer)).to be_a(ElocalApiSupport::Authorization::DefaultAuthorizer)
    end

    it 'requires a token' do
      get :index
      expect(response).to have_http_status(401)
      expect(response.body).to eq(error_response)
    end

    it 'does not allow wrong token' do
      get :index, request_token: 'ThisIsNotTheKey'
      expect(response).to have_http_status(401)
      expect(response.body).to eq(error_response)
    end

    it 'allows the right token' do
      get :index, request_token: 'mysecretkey'
      expect(response).to have_http_status(200)
    end
  end

  describe 'With Custom Authorizer' do
    controller do
      protected

      def authorizer
        FakeAuthorizer.new
      end
    end

    it 'uses the custom authorizer' do
      expect(controller.send(:find_authorizer)).to be_a(FakeAuthorizer)
    end

    it 'does not use default behavior' do
      get :index, request_token: 'mysecretkey'
      expect(response).to have_http_status(401)
    end

    it 'authorizes appropriately' do
      get :index, request_token: 'FakeAuthorizerKey'
      expect(response).to have_http_status(200)
    end
  end
end