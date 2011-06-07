require 'spec_helper'

describe ClubsController do
  #render the views inside the controller tests
  render_views
  
  
  describe "POST 'create'" do

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :login => "", :password => "",
                  :password_confirmation => "" }
      end
      # verify that a failed create action doesn’t create a club in the database
      # the number of clubs in the database is always the same
      it "should not create a club" do
      #wrap the post :create step in a package using a Ruby construct lambda
        lambda do
          post :create, :club => @attr
        end.should_not change(Club, :count)
      end

      it "should have the right title" do
        post :create, :club => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :club => @attr
        response.should render_template('new')
      end
      
      it "should have a welcome message" do
        post :create, :club => @attr
        flash.now[:error].should =~ /We couldn't set up that account, sorry.  Please try again, or contact an admin. /
      end
    end
    
    describe "success" do
     before(:each) do
        @attr = { :name => "Example Club",
              :login => "ex_c",
              :password=>"secret",
              :password_confirmation=>"secret",
              :address=>"hjshdjhsjd",
              :postale_code => '12134',
              :city =>'mainz'
         }
     end
      # verify that a succesed create action was create a club in the database
      # the number of clubs in the database += 1
      it "should create a club" do
        lambda do
          post :create, :club => @attr
        end.should change(Club, :count).by(1)
      end

      it "should redirect to the login page" do
        post :create, :club => @attr
        response.should redirect_to(login_path)
      end
      
      it "should have a welcome message" do
        post :create, :club => @attr
        flash[:success].should =~ /Thanks for signing up!/i
      end
    end
    
  end
  
  
  
  describe "GET 'show'" do

    before(:each) do
      @club = Factory(:club)
    end

    it "should be successful" do
      get :show, :id => @club
      response.should be_success
    end
    
    # verifies that the variable retrieved from the database in the action corresponds
    # to the @club instance created by Factory Girl.
    it "should find the right user" do
      get :show, :id => @club
      assigns(:club).should == @club
    end
    
    it "should have the right title" do
      get :show, :id => @club
      response.should have_selector("title", :content => @club.login)
    end
    
    it "should include the club's name" do
      get :show, :id => @club
      response.should have_selector("h1", :content => @club.login)
    end
    
    it "should have a profile image" do
      get :show, :id => @club
      response.should have_selector("h1>img", :class => "gravatar")
    end

  end
  
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
  
 
  
  it "should have the right title" do
    get 'new'
    response.should have_selector("title",:content => "Sign up")
  end
  
  
 
end