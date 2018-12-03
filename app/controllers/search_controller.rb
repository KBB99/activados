class SearchController < ApplicationController
  
  before_action :logged_in_user

  def search
    @user = User.find(current_user.id)
    @users = User.all
    @criteria = params[:search].split
    for term in @criteria do
      if params[:search]
        @users = @users.search(term).order("created_at DESC")
      else
        @users = @users.all.order("created_at DESC")
      end
    end
  end
end