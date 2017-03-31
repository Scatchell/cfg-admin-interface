require 'sinatra'
require 'sinatra/activerecord'
require 'aws-sdk'
require 'slim'
require 'bootstrap-sass'
require './config/environments' #database configuration
require './models/video' #Model class

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == 'mancity' and password == 'beautifulfootball'
end

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['mancity', 'beautifulfootball']
  end
end


get '/' do
  protected!

  @videos = []
  s3 = Aws::S3::Resource.new(region: 'eu-west-2', access_key_id: ENV['ACCESS_KEY_ID'], secret_access_key: ENV['SECRET_ACCESS_KEY'])

  bucket = s3.bucket('cfg-videos')
  bucket.objects.each do |obj|

    unless obj.key.start_with?('cfg-videos2017-0')
      @videos << Video.new(obj.key, obj.public_url)
    end
  end

  slim(:videos, :layout => true, :locals => {videos: @videos})

end