module AuthenticatedTestHelper
  # Sets the current club in the session from the club fixtures.
  def login_as(club)
    @request.session[:club_id] = club ? (club.is_a?(Club) ? club.id : clubs(club).id) : nil
  end

  def authorize_as(club)
    @request.env["HTTP_AUTHORIZATION"] = club ? ActionController::HttpAuthentication::Basic.encode_credentials(clubs(club).login, 'monkey') : nil
  end
  

end
