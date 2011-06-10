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
    
    it "should have a login form" do
      get :new
      response.should render_template('new')
    end
  end
  
  describe "POST 'create'" do
    describe "invalid log in" do
      before(:each) do
          @club_attr = { :login => "fc_miland", :password => "invalid" }
          @member_attr = { :email => "redais@hotmail.fr", :password => "invalid" }
          @attr= [@club_attr, @member_attr]
      end
      
      it "should re-render the new page" do
        @attr.each do |attr|
          post :create, :session => attr
          response.should render_template('new')
         end
      end
      
      
      it "should have the right title " do
        @attr.each do |attr|
          post :create, :session => attr
          response.should have_selector("title", :content => "Log in")
         end
      end
      
      it "should have a flash.now message" do
        @attr.each do |attr|
          post :create, :session => attr
          flash.now[:error].should =~ /Couldn't log you in as ''/i
        end
      end
    end
    
    describe "with valid login/email and password" do

      before(:each) do
        @club = Factory(:club)
        #@member= Factory(:member)
        @club_attr = { :login => "club_1", :password => "111111" }
        #@club_attr = { :login => @club.login, :password => @club.password }
      end

      it "should sign the club in" #do
        #post :create, :session => @club_attr
        #controller.current_club.should == @club
        #Club.find(session[:club_id]).should == @club
        #controller.should be_club_logged_in
       
      #end

      it "should redirect to the club home page" #do
        #post :create, :session => @club_attr
        #response.should redirect_to(club_path(@club))
      #end
    end
    
    
    
    
  end
  
  describe "DELETE 'destroy'" do
    it "should sign a club out" do
        test_club_sign_in(Factory(:club))
        delete :destroy
        controller.should_not be_club_logged_in
        response.should redirect_to(root_path)
    end
    it "should sign a member out" #do
        #test_club_sign_in(Factory(:member))
        #delete :destroy
        #controller.should_not be_member_logged_in
        #response.should redirect_to(root_path)
    #end
    
    
  end  
  

  
  
 
end