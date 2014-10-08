require 'spec_helper'
require_relative 'helpers/session'
include SessionHelpers

feature "User requires password change" do 
	
	before(:each) do
		User.create(:email => 'test@test.com',
			        :password => 'test',
			        :password_confirmation => 'test')
	end

	scenario 'when emails match' do
		visit 'reset_password'
		expect(page).not_to have_content ("Here is your token:")
		enter_email
		expect(page).to have_content ("Here is your token:")
	end

	scenario "when emails don't match" do
		visit 'reset_password'
		expect(page).not_to have_content ("The user does not exist")
        enter_email("email@email.com")
        expect(page).to have_content ("The user does not exist")
    end

		
	def enter_email(email = "test@test.com")
		visit 'reset_password' 
		expect(page.status_code).to eq(200)
		fill_in :email, :with => email
		click_on "Reset password"
	end
		
end

feature "User resets password" do
	
	before(:each) do
		User.create(:email => 'test@test.com',
			        :password => 'test',
			        :password_confirmation => 'test')


	end

	scenario "when token is valid" do
		visit '/reset_password'
	    enter_email
		user = User.first(:email => 'test@test.com')
		token = user.password_token 
		visit "/users/reset_password/#{token}"
		expect(page).to have_content("Email: New Password: Confirm New Password:")
	end

	scenario "when token is invalid" do
		visit '/users/reset_password/1bcde'
		expect(page).to have_content("The token is invalid")
	end

	scenario "when request has timed out" do
		visit '/reset_password'
		enter_email
		user = User.first(:email => 'test@test.com')

		request_time = user.password_token_timestamp
		user.password_token_timestamp = request_time - 7200
		user.save

		token = user.password_token
		visit "/users/reset_password/#{token}"
		expect(page).to have_content("The request has timed out")
	end


	def enter_email(email = "test@test.com")
		visit 'reset_password' 
		expect(page.status_code).to eq(200)
		fill_in :email, :with => email
		click_on "Reset password"
      
	end
end


