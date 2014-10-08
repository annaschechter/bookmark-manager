require 'data_mapper'
require './app/data_mapper_setup'
require './app/lib/link'
require './app/lib/tag'
require './app/lib/user'


task :auto_upgrade do 
	DataMapper.auto_upgrade!
	puts "Auto-upgrade complete (no data loss)"
end

task :auto_migrate do
	DataMapper.auto_migrate!
	puts "Auto-migrate complete (data could have been lost)"
end

# task :auto_migrate_TEST do
# 	ENV["RACK_ENV"] = 'TEST'
# 	DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
# 	DataMapper.auto_migrate!
# 	DataMapper.finalize
# 	puts "Auto-migrate complete (data could have been lost)"
# end

# task :auto_upgrade_TEST do 
# 	ENV["RACK_ENV"] = 'TEST'
# 	DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
# 	DataMapper.auto_upgrade!
# 	DataMapper.finalize
# 	puts "Auto-upgrade complete (no data loss)"
# end
