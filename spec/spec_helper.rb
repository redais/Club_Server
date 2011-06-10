# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  def integration_sign_in(club) 
          fill_in 'club_name',         :with => club.name
          fill_in "club_login",        :with => club.login
          fill_in "club_password",     :with => club.password
          fill_in "club_password_confirmation", :with => club.password_confirmation
          fill_in "club_address", :with => club.address
          fill_in "club_postale_code", :with => club.postale_code
          fill_in "club_city", :with => club.city
          fill_in "club_contact_person", :with => club.contact_person
      click_button
  end
  
  def test_club_sign_in(club)
    controller.create_club_sessions(club)
  end
  def test_member_sign_in(member)
    controller.create_club_sessions(member)
  end


end
