class MicropostsController < ApplicationController
  before_action :require_login, only: %i(create destroy)
  before_action :correct_user,  only: %i(destroy)
  permits :content, :picture

  def create(micropost)
    @micropost = current_user.microposts.build(micropost)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  def search
    @micropost  = current_user.microposts.build
    @feed_items = Micropost.includes(:user).content_like(params[:content]).page(params[:page])
  end

  private
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
