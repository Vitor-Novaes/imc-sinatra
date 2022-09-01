require 'jwt'
require_relative './helpers'

module JWTStrategy
  include Helpers

  def protected!
    return if authorized?

    halt_unauthenticated
  end

  def extract_token
    token = request.env['HTTP_ACCESS_TOKEN']
    return token if token

    token = session['access_token']
    return token if token

    nil
  end

  def authorized?
    @token = extract_token

    if @token.nil?
      return false
    end

    begin
      @payload, @header = JWT.decode(@token, settings.signing_key, true, { algorithm: 'RS256' })

      @exp = @header['exp']

      if @exp.nil?
        return false
      end

      @exp = Time.at(@exp.to_i)

      if Time.now > @exp
        return false
      end

      @payload['inner_auth'] == ENV['INNER_AUTH']
    rescue JWT::DecodeError => e
      false
    end
  end

  def encode_token(inner)
    headers = {
      exp: Time.now.to_i + 1200
    }

    JWT.encode({ inner_auth: inner }, settings.signing_key, 'RS256', headers)
  end
end
