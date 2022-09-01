# config.ru
require './config/environment'

run Rack::URLMap.new('/' => Server)
