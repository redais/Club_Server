require 'spec_helper'

describe SessionsController do
  #render the views inside the controller tests
  render_views
  
  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Log in")
    end
  end
  
  describe "POST 'create'" do
    describe "invalid sign in" do
      before(:each) do
          @attr = { :login => "fc_miland", :password => "invalid" }
      end
      
      it "should re-render the new page" do
          post :create, :session => @attr
          response.should render_template('new')
      end
      
      it "should have the right title" do
          post :create, :session => @attr
          response.should have_selector("title", :content => "Log in")
      end
      
      it "should have a flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /Couldn't log you in as ''/i
      end
    end
    
    describe "with valid login and password" do

      before(:each) do
        @club = Factory(:club)
        @attr = { :login => @club.login, :password => @club.password }
      end

      it "should sign the club in" do
        post :create, :session => @attr
       puts "########################################"
        #puts controller.current_club.login
        #controller.current_club.should == @club
       puts "########################################"
      
       #controller.should be_logged_in
      end

      it "should redirect to the club home page" do
        post :create, :session => @attr
        #response.should redirect_to(root_path)
      end
    end
    
    describe "DELETE 'destroy'" do

      it "should sign a club out" do
        test_sign_in(Factory(:club))
        delete :destroy
        controller.should_not be_logged_in
      response.should redirect_to(root_path)
    end
  end
    
    
  end
  
  
  

  
  
 
end