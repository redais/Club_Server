require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end
  
  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
  end
  
  it "should have a login page at '/login'" do
    get '/login'
    response.should have_selector('title', :content => "Log in")
    response.should have_selector('a', :href =>login_path, :content => "Log in")
  end
  
  it "should have a clubs page at '/clubs'" do
    get '/clubs'
    response.should have_selector('title', :content => "All clubs")
    response.should have_selector('a', :href =>'/clubs', :content => "Clubs")
  end
  
  it "should have a Events page at ''" 
  
  
  describe "when signed in" do

    before(:each) do
      @club = Factory(:club)
      visit login_path
      fill_in :login,    :with => @club.login
      fill_in :password, :with => @club.password
      click_button
    end

    it "should have a log out link" do
      visit root_path
      response.should have_selector("a", :href => logout_path,:content => "Sign out[#{@club.login}]")
    end

    it "should have a profile link"
    
  end
  

  
end

