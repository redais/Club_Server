require 'spec_helper'

describe "Clubs" do
  describe 'signup' do
    
    describe 'failure' do
      it "should not make a new club" do
        # verify that the code inside the lambda block doesn’t change the value of Club.count.
        lambda do
          visit signup_path
          fill_in 'club_name',         :with => ""
          fill_in "club_login",        :with => ""
          fill_in "club_password",     :with => ""
          fill_in "club_password_confirmation", :with => ""
          fill_in "club_address", :with => ""
          fill_in "club_postale_code", :with => ""
          fill_in "club_city", :with => ""
          fill_in "club_contact_person", :with => ''
          click_button
          response.should render_template('clubs/new')
          response.should have_selector("div#errorExplanation")
        end.should_not change(Club, :count)
      end
    end
    
    describe 'success' do
      before(:each) do
        @club = Factory(:club)
      end
      lambda do
        it "should make a new club" do
          visit signup_path
          integration_sign_in(@club)
          response.should have_selector("div.flash.success",
                                        :content => "Thanks for signing up! ")
          response.should render_template('sessions/new')
        end.should change(Club,:count).by(1)
      end
    
    end 
  end
end
