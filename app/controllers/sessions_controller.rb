# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #include AuthenticatedSystem

  # render new.rhtml
  def new
    @title="Log in"
  end

  def create
    logout_keeping_session!
    club = Club.authenticate(params[:login], params[:password])
    member= Member.authenticate(params[:login], params[:password])
    if club
      # Protects against session fixation attacks, causes request forgery
      # protection if club resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      create_club_sessions(club)
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      #redirect_back_or_default('/', :notice => "Logged in successfully")
      redirect_to(club, :success => "Logged in successfully as club")
    elsif member
      create_member_sessions(member)
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      #redirect_back_or_default('/', :notice => "Logged in successfully")
      redirect_to(member, :success => "Logged in successfully as member")
    
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      @title="Log in"
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    redirect_back_or_default('/', :notice => "You have been logged out.")
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
