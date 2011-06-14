require 'spec_helper'

describe Member do

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
        @club= Factory(:club)
      
   
  end

  it "should create a new instance given valid attributes" do
    @club.members.create!(@attr)
  end
 
 it "should require a firstname" do
    #use merge to make a new club called no_name_user with a blank name
    no_first_name_member = @club.members.new(@attr.merge(:first_name => ""))
    #the resulting club is not valid
    no_first_name_member.should_not be_valid
 end
  
  
 it "should require a last_name" do
    no_last_name_member = @club.members.new(@attr.merge(:last_name => ""))
    no_last_name_member.should_not be_valid
  end
  
  it "should require an email" do
    no_email_member = @club.members.new(@attr.merge(:email => ""))
    no_email_member.should_not be_valid
  end
  
  it "should require a password" do
    no_password_member = @club.members.new(@attr.merge(:password => ""))
    no_password_member.should_not be_valid
  end
  
  it "should require an address" do
    no_address_member = @club.members.new(@attr.merge(:address => ""))
    no_address_member.should_not be_valid
  end
  
  it "should require a postale code" do
    no_postale_code_member = @club.members.new(@attr.merge(:postale_code => ""))
    no_postale_code_member.should_not be_valid
  end
  
  
  
  it "should require a city" do
    no_city_member = @club.members.new(@attr.merge(:city => ""))
    no_city_member.should_not be_valid
  end
  
  it "should require a gender" do
    no_gender_member = @club.members.new(@attr.merge(:sex => ""))
    no_gender_member.should_not be_valid
  end
  
  it "should reject firstnames that are too long" do
    long_firstname = "a" * 51
    long_firstname_member = @club.members.new(@attr.merge(:first_name => long_firstname))
    long_firstname_member.should_not be_valid
  end
  
  it "should reject lastnames that are too long" do
    long_last_name = "a" * 51
    long_last_name_member = @club.members.new(@attr.merge(:last_name => long_last_name))
    long_last_name_member.should_not be_valid
  end
  
  it "should reject duplicate email addresses" do
    # Put a Member with given email address into the database.
    @club.members.create!(@attr)
    member_with_duplicate_email = @club.members.new(@attr)
    member_with_duplicate_email.should_not be_valid
  end
  
  describe "email validations" do
    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_member = @club.members.new(@attr.merge(:email => address))
        valid_email_member.should be_valid
     end
    end

    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_member = @club.members.new(@attr.merge(:email => address))
        invalid_email_member.should_not be_valid
      end
    end
  end
  
  describe "gender validations" do
    it "should accept valid genders" do
      genders = %w[male female]
      genders.each do |gender|
        valid_gender_member = @club.members.new(@attr.merge(:gender => gender))
        valid_gender_member.should be_valid
     end
    end

    it "should reject invalid genders" #do
      #genders = %w[ds fm fmale c sdh sdkj test]
      #genders.each do |gender|
        #invalid_gender_member = @club.members.new(@attr.merge(:gender => gender))
        #invalid_gender_member.should_not be_valid
     #end
    #end
  end
  
  
  describe "password validations" do
    it "should require a password" do
      @club.members.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      @club.members.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      @club.members.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      @club.members.new(hash).should_not be_valid
    end
  end
  
  
  describe "password encryption" do

    before(:each) do
      @member = @club.members.create!(@attr)
    end

    it "should have a crypted password attribute" do
      @member.should respond_to(:crypted_password)
    end
    
    it "should set the encrypted password" do
      @member.crypted_password.should_not be_blank
    end
    
    describe "authenticate method" do

      it "should return nil on login/password mismatch" do
        wrong_password_member = @club.members.authenticate(@attr[:email], "wrongpass")
        wrong_password_member.should be_nil
      end

      it "should return nil for a login with no member" do
        nonexistent_member = @club.members.authenticate("wrong_login", @attr[:password])
        nonexistent_member.should be_nil
      end

      it "should return the member on email/password match" do
        matching_member = @club.members.authenticate(@attr[:email], @attr[:password])
        matching_member.should == @member
      end
    end
    
    describe "authenticated? method" do

      it "should be true if the passwords match" do
        @member.authenticated?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @member.authenticated?("invalid").should be_false
      end 
   end
  end
  
  describe "club associations" do

    before(:each) do
      @member = @club.members.create(@attr)
    end

    it "should have a club attribute" do
      @member.should respond_to(:club)
    end

    it "should have the right associated club" do
      @member.club_id.should == @club.id
      @member.club.should == @club
    end
  end


end

