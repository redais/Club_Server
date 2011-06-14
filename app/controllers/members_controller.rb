class MembersController < ApplicationController
 
 before_filter :member_login_required, :only => [:show, :edit, :update ]
 #before_filter :member_club, :only => [:new ]

  # GET /members/1
  # GET /members/1.xml
  def show
    @member = Member.find(params[:id])
    #@members = Member.paginate(:page => params[:page])
    @title = @member.last_name
    #respond_to do |format|
     # format.html # show.html.erb
     # format.xml  { render :xml => @member }
    #end
  end

  # GET /members/new
  
  def new
    @title="Sign up"
    #@club=Club.find(session[:current_club])
    @member = Member.new unless session[:current_club]==nil
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.xml
  def create
    @club=Club.find(session[:current_club])
    @title="Sign up"
    logout_keeping_session!
    @member = @club.members.build(params[:member])
    success = @member && @member.save
   
   
      if success
        session[:current_club]=nil
        # Member dem Club zuordnen
        # @club.members << @member
        flash[:success] = "Member created for #{@club.name}"
        redirect_to(login_path)
      else
        flash.now[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin. "
        render :action => 'new'
      end
    
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to(@member, :notice => 'Member was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
    #@member = Member.find(params[:id])
    @member.destroy

    redirect_back_or_default(root_path)
  end
  
  private
  
    def member_club
      redirect_to("/") if session[:current_club] == nil
      #flash[:notice] = "denied acces"
    end
end
