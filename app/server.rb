require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require 'sinatra/partial'

require_relative'./controllers/links'
require_relative './controllers/tags'
require_relative './controllers/users'
require_relative './controllers/passwords'
require_relative './controllers/sessions'
require_relative './controllers/application'

require_relative 'helpers/application.rb'
require_relative 'data_mapper_setup'

use Rack::Flash, :sweep =>true

enable :sessions
set :session_secret, 'super secret'
set :public_folder, Proc.new{ File.join(root, '..', 'public')}
set :partial_template_engine, :erb

