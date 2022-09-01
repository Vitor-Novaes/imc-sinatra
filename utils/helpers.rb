require 'json'

module Helpers
  def json_params
    JSON.parse(request.body.read, symbolize_names: true)
  rescue JSON::ParserError
    halt 400, { message: 'Invalid JSON' }.to_json
  end

  def halt_error_content_type_request
    halt 400, { message: 'Only accept JSON requests' }.to_json
  end

  def halt_error_type_content(exception)
    halt 422, { message: exception.message }.to_json
  end

  def halt_general_error
    halt 400, { message: 'Something wrong' }.to_json
  end

  def halt_forbidden
    halt 403, { message: 'Unauthorized Token. Please verify token and try again' }.to_json
  end

  def halt_unauthenticated
    halt 401, { error: 'Unauthenticated' }.to_json
  end

  def halt_login_failed
    halt 200, { error: 'Inner Auth Credentials Failed' }.to_json
  end
end
