class LikesController < ApplicationController
  before_action :signed_in_user

  def create
    @micropost = Micropost.find(params[:like][:micropost_id])
    current_user.like!(@micropost)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def destroy
    @micropost = Like.find(params[:id]).micropost
    current_user.unlike!(@micropost)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end
end