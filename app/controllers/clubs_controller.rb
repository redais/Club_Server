class ClubsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #include AuthenticatedSystem
  
  
  # The application code gets these tests to pass using a before filter,
  # which arranges for a particular method to be called before the given actions. 
  # In this case, we define an login_required method (see sessionshelper)
  before_filter :club_login_required, :only => [ :edit, :update ]
  
  
  #requiring clubs to sign in isn’t quite enough
  #clubs should only be allowed to edit their own information
  before_filter :correct_club, :only => [:edit, :update]
  
  @current_club
  
  # GET /clubs
  # GET /clubs.xml
  def index
    #@clubs = Club.all
    @clubs = Club.paginate(:page => params[:page])
    @title="All clubs"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clubs }
    end
  end

  # render new.rhtml
  def new
    @title="Sign up"
    @club = Club.new
  
  end
 
  def create
    @title="Sign up"
    logout_keeping_session!
    @club = Club.new(params[:club])

    success = @club && @club.save

    if success && @club.errors.empty?
      
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
       @current_club = @club # !! now logged in
       redirect_to(login_path)
       flash[:success]="Thanks for signing up! "
    else
      flash.now[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin. "
      render :action => 'new'
    end
  end
  
  def show
    @club = Club.find(params[:id])
    @members=@club.members.paginate(:page => params[:page])
    #@members=@club.members.paginate(:page => params[10])
    
    session[:current_club] = @club.id
    @title = @club.login
    #respond_to do |format|
      #format.html # show.html.erb
      #format.xml  { render :xml => @student }
    #end
  end
  
  def edit
    @club = Club.find(params[:id])
    @title= "Edit club"
  end
  
  def update
     @club = Club.find(params[:id])
     @title ='club update'
    respond_to do |format|
      if @club.update_attributes(params[:club])
        format.html { redirect_to @club }
        flash[:success] = "Club was successfully updated."
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
    def correct_club
      @club = Club.find(params[:id])
      redirect_to(root_path) unless session[:club_id] == @club.id
      flash[:notice] = "denied acces"
    end
  
  


end
