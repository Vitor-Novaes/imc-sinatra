require 'spec_helper'
require 'rspec'
require 'rack/test'
require_relative '../server'

set :environment, :test

module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(last_response.body, symbolize_names: true)
    end
  end
end

# TODO
RSpec.describe Server do
  include Request::JsonHelpers

  it 'GET /status' do
    get '/status'

    expect(last_response).to have_http_status(:ok)
  end
end
