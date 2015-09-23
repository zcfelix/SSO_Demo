class StaticPagesController < ApplicationController
  def home
  end

  def redirect
  end
  
  def get_token
    token = params[:token]
  end 
end
