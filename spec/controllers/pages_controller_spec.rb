require 'spec_helper'

describe PagesController do
  #render the views inside the controller tests
  render_views
  
  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end
  
  #check for an HTML element (the “selector”) with the given content
  it "should have the right title" do
    get 'home'
    response.should have_selector("title",:content => "Home")
  end
  
  
 
end