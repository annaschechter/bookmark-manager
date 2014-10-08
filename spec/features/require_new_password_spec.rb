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
		expect(page).not_to have_content ("The new password has been sent to your email account.")
		enter_email
		expect(page).to have_content ("The new password has been sent to your email account.")
	end
		
    def enter_email(email = "test@test.com")
    	visit 'reset_password' 
    	expect(page.status_code).to eq(200)
    	fill_in :email, :with => email
    	click_on "Reset password"
    end
    	
end