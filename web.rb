require 'sinatra'

get '/tip' do
  'Put this in your pipe & smoke it!'
end

class MyApp < Sinatra::Base
  set :sessions, true
  set :foo, 'bar'

  get '/' do
    'Hello world!'
  end
end
