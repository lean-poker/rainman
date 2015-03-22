require_relative 'app'

map '/' do
  run Sinatra::Application
end
