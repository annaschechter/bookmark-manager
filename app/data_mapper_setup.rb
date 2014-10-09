env = ENV["RACK_ENV"] || "development"
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/bookmark_manager_#{env}")

require_relative 'models/link'
require_relative 'models/tag'
require_relative 'models/user'

DataMapper.auto_upgrade!
DataMapper.finalize
