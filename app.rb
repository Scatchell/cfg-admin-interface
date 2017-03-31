require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/model'        #Model class

get '/' do
  erb :index
end

post '/submit' do
  postedModel = JSON.parse(request.body.read)
  @model = Model.new(postedModel)
  if @model.save
	redirect '/models'
  else
	"Sorry, there was an error!"
  end
end

get '/models' do
  @models = Model.all
  erb :models
end

get '/model/last' do
  content_type :json
  Model.last.to_json
end
