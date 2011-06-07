require File.dirname(__FILE__) + '/../test_helper'
require 'clubs_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class ClubsControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :clubs

  def test_should_allow_signup
    assert_difference 'Club.count' do
      create_club
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'Club.count' do
      create_club(:login => nil)
      assert assigns(:club).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'Club.count' do
      create_club(:password => nil)
      assert assigns(:club).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'Club.count' do
      create_club(:password_confirmation => nil)
      assert assigns(:club).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'Club.count' do
      create_club(:email => nil)
      assert assigns(:club).errors.on(:email)
      assert_response :success
    end
  end
  

  

  protected
    def create_club(options = {})
      post :create, :club => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
