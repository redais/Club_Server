module SessionsHelper
  
  
    

 
    
    def current_club
      $current_club     # Useless! Don't use this line.
    end
    
  
    # Returns true or false if the club is logged in.
    # Preloads @current_club with the club model if they're logged in.
    def club_logged_in?
      #!!current_club
      !session[:club_id].nil?
      
    end
    def member_logged_in?
      #!!current_club
      !session[:member_id].nil?
    end
    
    
   
    

    # Accesses the current club from the session.
    # Future calls avoid the database because nil is not equal to false.
    #def current_club
    #  @current_club ||= (login_from_session || login_from_basic_auth || login_from_cookie) 
    #end

    # Store the given club id in the session.
    def create_club_sessions(new_club)
      session[:club_id] = new_club ? new_club.id : nil
      self.current_club = new_club
    end
    
    def current_club=(club)
      @current_club = club
    end
    
    def current_user
      @current_user     # Useless! Don't use this line.
    end
    
    
    def create_member_sessions(new_member)
      session[:member_id] = new_member ? new_member.id : nil
      #$current_club = new_club || false
    end
    
   
    
    
   
  
   #def current_club=(club)
    #@current_club = club
  #end

    # Check if the club is authorized
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the club
    # has the correct rights.
    #
    # Example:
    #
    #  # only allow nonbobs
    #  def authorized?
    #    current_club.login != "bob"
    #  end
    #
    def club_authorized?(action = action_name, resource = nil)
      club_logged_in?
    end
    def member_authorized?(action = action_name, resource = nil)
      member_logged_in?
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def club_login_required
      club_authorized? || access_denied
    end
    def member_login_required
      member_authorized? || access_denied
    end

    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the club is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied
      respond_to do |format|
        format.html do
          store_location
          redirect_to new_session_path, :notice => "Please sign in to access this page."
        end
        # format.any doesn't work in rails version < http://dev.rubyonrails.org/changeset/8987
        # Add any other API formats here.  (Some browsers, notably IE6, send Accept: */* and trigger 
        # the 'format.any' block incorrectly. See http://bit.ly/ie6_borken or http://bit.ly/ie6_borken2
        # for a workaround.)
        format.any(:json, :xml) do
          request_http_basic_authentication 'Web Password'
        end
      end
    end

    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.  Set an appropriately modified
    #   after_filter :store_location, :only => [:index, :new, :show, :edit]
    # for any controller you want to be bounce-backable.
    def redirect_back_or_default(default, options = {})
      redirect_to((session[:return_to] || default), options)
      session[:return_to] = nil
    end

    # Inclusion hook to make #current_club and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_club, :club_logged_in?, :authorized? if base.respond_to? :helper_method
    end

    #
    # Login
    #

    # Called from #current_club.  First attempt to login by the club id stored in the session.
    def login_from_session
      self.current_club = club.find_by_id(session[:club_id]) if session[:club_id]
    end

    # Called from #current_club.  Now, attempt to login by basic authentication information.
    def login_from_basic_auth
      authenticate_with_http_basic do |login, password|
        self.current_club = Club.authenticate(login, password)
      end
    end
    
    #
    # Logout
    #

    # Called from #current_club.  Finaly, attempt to login by an expiring token in the cookie.
    # for the paranoid: we _should_ be storing club_token = hash(cookie_token, request IP)
    def login_from_cookie
      club = cookies[:auth_token] && Club.find_by_remember_token(cookies[:auth_token].value)
      if club && club.remember_token?
        self.current_club = club
        handle_remember_cookie! false # freshen cookie token (keeping date)
        self.current_club
      end
    end

    # This is ususally what you want; resetting the session willy-nilly wreaks
    # havoc with forgery protection, and is only strictly necessary on login.
    # However, **all session state variables should be unset here**.
    def logout_keeping_session!
      # Kill server-side auth cookie
      @current_club.forget_me if @current_club.is_a? Club
      @current_club = false     # not logged in, and don't do it for me
      kill_remember_cookie!     # Kill client-side auth cookie
      cookies.delete(:remember_token)
      session[:club_id] = nil   # keeps the session but kill our variable
      session[:member_id]= nil
      # explicitly kill any other session variables you set
    end

    # The session should only be reset at the tail end of a form POST --
    # otherwise the request forgery protection fails. It's only really necessary
    # when you cross quarantine (logged-out to logged-in).
    def logout_killing_session!
      logout_keeping_session!
      reset_session
    end
    
    #
    # Remember_me Tokens
    #
    # Cookies shouldn't be allowed to persist past their freshness date,
    # and they should be changed at each login

    # Cookies shouldn't be allowed to persist past their freshness date,
    # and they should be changed at each login

    def valid_remember_cookie?
      return nil unless @current_club
      (@current_club.remember_token?) && 
        (cookies[:auth_token] == @current_club.remember_token)
    end
    
    # Refresh the cookie auth token if it exists, create it otherwise
    def handle_remember_cookie!(new_cookie_flag)
      return unless @current_club
      case
      when valid_remember_cookie? then @current_club.refresh_token # keeping same expiry date
      when new_cookie_flag        then @current_club.remember_me 
      else                             @current_club.forget_me
      end
      send_remember_cookie!
    end
  
    def kill_remember_cookie!
      cookies.delete :auth_token
    end
    
    def send_remember_cookie!
      cookies[:auth_token] = {
        :value   => @current_club.remember_token,
        :expires => @current_club.remember_token_expires_at }
    end
    
    private

    def member_from_remember_token
      Member.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end


end