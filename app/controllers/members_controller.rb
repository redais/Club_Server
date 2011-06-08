class MembersController < ApplicationController
  # GET /members
  # GET /members.xml
  def index
    @members = Member.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @members }
    end
  end

  # GET /members/1
  # GET /members/1.xml
  def show
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/new
  
  def new
    @title="Sign up"
    @member = Member.new
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
        @club.members << @member
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
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(members_url) }
      format.xml  { head :ok }
    end
  end
end
