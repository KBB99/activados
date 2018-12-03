
class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = User.find(current_user.id)
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
    if logged_in?
      @user = User.find(current_user.id)
      @microposts = Micropost.all.paginate(page: params[:page])
    end
  end

  def about
    if logged_in?
      @user = User.find(current_user.id)
    else
      redirect_to '/login'
    end
  end
  
  def contact
  end
  
end
