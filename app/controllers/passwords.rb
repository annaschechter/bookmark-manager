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