require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require 'sinatra/partial'

require_relative'./lib/link'
require_relative './lib/tag'
require_relative './lib/user'
require_relative 'helpers/application.rb'
require_relative 'data_mapper_setup'

use Rack::Flash, :sweep =>true

enable :sessions
set :session_secret, 'super secret'
set :public_folder, Proc.new{ File.join(root, '..', 'public')}
set :partial_template_engine, :erb


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

get '/sessions/new' do
	erb :"sessions/new"
end

post '/sessions' do
	email, password = params[:email], params[:password]
	user = User.authenticate(email, password)
	if user
		session[:user_id] = user.id
        redirect to('/')
    else
    	flash[:errors] = ["The email or password is incorrect"]
    	erb :"sessions/new"
    end
end

delete '/sessions' do
	session[:user_id] = nil
	"Good bye!"
end

get '/reset_password' do
	erb :"users/reset_password"
end

post '/reset_password' do
	email = params[:email]
	user = User.first(:email => email)
	if user
		@password_token = (1..64).map{('A'..'Z').to_a.sample}.join
		user.password_token = @password_token
		user.password_token_timestamp = Time.now
		user.save
		"Here is your token: #{@password_token} ."
	else
		flash[:errors] = ["The user does not exist"]
	end
end

get '/users/reset_password/:token' do
    user = User.first(:password_token => params[:token])
    if user
       request_time = user.password_token_timestamp
    	if Time.now - request_time < 3600
    		erb :"users/enter_new_password"
    	else 
    		flash[:errors] = ["The request has timed out"]
    	end
    else
    	flash[:errors] = ["The token is invalid"]
    end
end

get '/reset_successful' do
	user = User.first(:email=> params[:email])
	flash[:errors] = ["This user does not exist"] unless user
	if params[:new_password] == params[:new_password_confirm] 
		user.password_digest = BCrypt::Password.create(params[:new_password])
		user.save
		"Your password has been successfully reset"
	else
		flash[:errors] = ["The passwords do not match"]
		erb :"users/enter_new_password"
	end 
end
