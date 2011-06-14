require 'spec_helper'

describe ClubsController do
  #render the views inside the controller tests
  render_views
  
  describe "POST 'create'" do
    
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :login => "", :password => "",:password_confirmation => "" }
      end
      
      # verify that a failed create action doesn’t create a club in the database
      # the number of clubs in the database is always the same
      #wrap the post :create step in a package using a Ruby construct lambda
      it "should not create a club" do
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
                  :city =>'mainz',
                  :contact_person=>'foo'
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
      @attr = { :first_name => "first",
              :last_name => "last",
              :email => "email@test.com",
              :password=>"secret",
              :password_confirmation=>"secret",
              :address=>"hjshdjhsjd",
              :postale_code => '12134',
              :city =>'mainz',
              :sex=>"male",
              :chip_id=>"76176238"
              
             }
      @club = Factory(:club)
    end
    it "should be successful" do
      get :show, :id => @club
      response.should be_success
    end
    
    # verifies that the variable retrieved from the database in the action corresponds
    # to the @club instance created by Factory Girl.
    it "should find the right club" #do
      #get :show, :id => @club.id
      #assigns(:club).should == @club
    #end
    
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
    it "should show the club's members" #do
      #m1 = Factory(:member, :club => @club)
      #m2 = @club.members.create!(@attr)
      #get :show, :id => @club
      #response.should have_selector(".member")
      
    #end
  end
  
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title",:content => "Sign up")
    end
    it "should have a signup Form" do
      get 'new'
      response.should have_selector("form")
    end
    
  end
  
  
  describe "GET 'edit'" do

    before(:each) do
      @club = Factory(:club)
      test_club_sign_in(@club)
    end

    it "should be successful" do
      get :edit, :id => @club
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @club
      response.should have_selector("title", :content => "Edit club")
    end

    
  end
  
  describe "PUT 'update'" do

    before(:each) do
      @club = Factory(:club)
      test_club_sign_in(@club)
    end

    describe "failure" do

      before(:each) do
        @attr = { :name => "",
                  :login => "",
                  :password=>"",
                  :password_confirmation=>"",
                  :address=>"",
                  :postale_code => '',
                  :city =>'',
                  :contact_person=>''
                 }
      end

      it "should render the 'edit' page" do
        put :update, :id => @club, :club => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @club, :club => @attr
        response.should have_selector("title", :content => "club update")
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :name => "New Name", :login => "club",
                  :password => "barbaz", :password_confirmation => "barbaz",:address=>"test 10",
                  :postale_code => '11234',
                  :city =>'Mainz',
                  :contact_person=>'test' }
      end
      it "should change the user's attributes" do
        put :update, :id => @club, :club => @attr
        @club.reload
        @club.name.should  == @attr[:name]
        @club.login.should == @attr[:login]
      end

      it "should redirect to the club show page" do
        put :update, :id => @club, :club => @attr
        response.should redirect_to(club_path(@club))
      end

      it "should have a flash message" do
        put :update, :id => @club, :club => @attr
        flash[:success].should =~ /Club was successfully updated./i
      end
  end
  
  
end

describe "authentication of edit/update pages" do

    before(:each) do
      @club = Factory(:club)
    end

    describe "for non-logged-in clubs" do

      it "should deny access to 'edit'" do
        get :edit, :id => @club
        response.should redirect_to(new_session_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @club, :club => {}
        response.should redirect_to(new_session_path)
      end
  end
  
  describe "for logged-in clubs" do

      before(:each) do
        wrong_club = Factory(:club, :login => "example")
        test_club_sign_in(wrong_club)
      end

      it "should require matching club for 'edit'" do
        get :edit, :id => @club
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @club, :club => {}
        response.should redirect_to(root_path)
      end
    end
end
  
 
  
  
  
  
 
end