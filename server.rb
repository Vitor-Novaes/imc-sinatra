require 'sinatra'
require 'openssl'
require 'dotenv'
require_relative './model/imc'
require_relative './serializer/imc_serializer'
require_relative './utils/helpers'
require_relative './utils/jwt_strategy'

Dotenv.load

set :port, 3000
set :bind, '0.0.0.0'

class Server < Sinatra::Base
  include Helpers
  include JWTStrategy

  # Secret RSA JWT Generator
  rsa_private = OpenSSL::PKey::RSA.generate 2048
  rsa_public = rsa_private.public_key

  set :signing_key, rsa_private # Setting Sinatra config value
  set :verify_key, rsa_public
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET'] # Session rack.cookies save in secret payload

  before do
    content_type 'application/json'

    halt_error_content_type_request if request.request_method == 'POST' && request.content_type != 'application/json'
  end

  get '/status' do
    halt 200, {
      status: 'up',
      version: 1
    }.to_json
  end

  post '/imc' do
    protected!

    imc = IMC.new(json_params)
    halt 200, IMCSerializer.new(imc).as_json

  rescue TypeError => e
    halt_error_type_content(e)
  rescue StandardError
    halt_general_error
  end

  get '/logout' do
    session['access_token'] = nil
    halt 200, { message: 'Session end successfuly' }.to_json
  end

  post '/login' do
    auth = json_params
    if auth[:inner_token] == ENV['INNER_AUTH']
      session['access_token'] = nil
      @token = encode_token(auth[:inner_token])
      session['access_token'] = @token

      halt 200, { message: 'Logged', token: @token }.to_json
    else
      halt_login_failed
    end
  end
end
