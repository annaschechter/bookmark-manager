require 'sinatra'
require 'data_mapper'
require 'rack-flash'

require_relative'./lib/link'
require_relative './lib/tag'
require_relative './lib/user'
require_relative 'application.rb'

use Rack::Flash, :sweep =>true

enable :sessions
set :session_secret, 'super secret'

env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")



DataMapper.finalize
DataMapper.auto_upgrade!



get '/' do 
	@links = Link.all
	erb :index	
end

post '/links' do
	url = params["url"]
	title = params["title"]
	tags = params["tags"].split(" ").map{|tag| Tag.first_or_create(:text => tag)}
	Link.create(:url => url, :title => title, :tags => tags)
	redirect to '/'
end

get '/tags/:text' do
	tag = Tag.first(:text => params[:text])
	@links = tag ? tag.links : []
	erb :index
end

get '/users/new' do
	@user = User.new
	erb :"users/new"
end

post '/users' do
	@user = User.create(:email => params[:email],
		        :password => params[:password],
		        :password_confirmation => params[:password_confirmation])
	if @user.save
		session[:user_id] = @user.id
		redirect to('/')
    else
    	flash.now[:errors] = @user.errors.full_messages
    	erb :"users/new"
    end
end


