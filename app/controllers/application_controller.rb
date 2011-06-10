class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ClubsHelper
  include MembersHelper
end
