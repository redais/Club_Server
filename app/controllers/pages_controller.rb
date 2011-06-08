class PagesController < ApplicationController
  
  
  def home
    @title="Home"
    if session[:club_id]!= nil
      redirect_to(Club.find(session[:club_id]))
    end
  end
  
  
end
