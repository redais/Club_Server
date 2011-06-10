require 'spec_helper'

describe Club do
  

  before(:each) do
    @attr = { :name => "Example Club",
              :login => "ex_c",
              :password=>"secret",
              :password_confirmation=>"secret",
              :address=>"hjshdjhsjd",
              :postale_code => '12134',
              :city =>'mainz',
              :contact_person=>"foo"
             }
  end

  it "should create a new instance given valid attributes" do
    Club.create!(@attr)
  end

  it "should require a name" do
    #use merge to make a new club called no_name_user with a blank name
    no_name_club = Club.new(@attr.merge(:name => ""))
    #the resulting club is not valid
    no_name_club.should_not be_valid
  end
  
  it "should require a login" do
    no_login_club = Club.new(@attr.merge(:login => ""))
    no_login_club.should_not be_valid
  end
  
  it "should require a password" do
    no_password_club = Club.new(@attr.merge(:password => ""))
    no_password_club.should_not be_valid
  end
  
  it "should require an address" do
    no_address_club = Club.new(@attr.merge(:address => ""))
    no_address_club.should_not be_valid
  end
  
  it "should require a postale code" do
    no_postale_code_club = Club.new(@attr.merge(:postale_code => ""))
    no_postale_code_club.should_not be_valid
  end
  
  
  
  it "should require a city" do
    no_city_club = Club.new(@attr.merge(:city => ""))
    no_city_club.should_not be_valid
  end
  
  it "should require a contact person" do
    no_contact_person_club = Club.new(@attr.merge(:contact_person => ""))
    no_contact_person_club.should_not be_valid
  end
  
  it "should reject duplicate logins" do
    # Put a user with given email address into the database.
    Club.create!(@attr)
    club_with_duplicate_login = Club.new(@attr)
    club_with_duplicate_login.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_club = Club.new(@attr.merge(:name => long_name))
    long_name_club.should_not be_valid
  end
  
  describe "password validations" do

    it "should require a password" do
      Club.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      Club.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      Club.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      Club.new(hash).should_not be_valid
    end
  end
  
  
  describe "password encryption" do

    before(:each) do
      @club = Club.create!(@attr)
    end

    it "should have a crypted password attribute" do
      @club.should respond_to(:crypted_password)
    end
    
    it "should set the encrypted password" do
      @club.crypted_password.should_not be_blank
    end
    
    describe "authenticate method" do

      it "should return nil on login/password mismatch" do
        wrong_password_club = Club.authenticate(@attr[:login], "wrongpass")
        wrong_password_club.should be_nil
      end

      it "should return nil for a login with no club" do
        nonexistent_club = Club.authenticate("wrong_login", @attr[:password])
        nonexistent_club.should be_nil
      end

      it "should return the club on login/password match" do
        matching_club = Club.authenticate(@attr[:login], @attr[:password])
        matching_club.should == @club
      end
    end
    
    describe "authenticated? method" do

      it "should be true if the passwords match" do
        @club.authenticated?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @club.authenticated?("invalid").should be_false
      end 
   end
  end
  
  
  
 
  
  
  
  
end