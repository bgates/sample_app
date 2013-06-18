class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @micropost = current_user.microposts.build 
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'logged_in_home'
    end
  end

  def help
  end

  def about
    
  end

  def contact

  end
end
