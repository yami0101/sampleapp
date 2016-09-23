class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy, :followers, :following]
  before_action :correct_user, only: [:edit, :update]
  before_action :unsigned_in_user, only: [:new, :create]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def update_status
    p current_user.valid?
    p current_user.errors.full_messages
    p current_user.password
    if current_user.update_attribute(:status, user_params[:status])
      respond_to do |format|
        format.js {}
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def liked
    @title = "Liked Microposts"
    @user = User.find(params[:id])
    @microposts = []
    @user.likes.each do |like|
      @microposts << like.micropost
    end
    @microposts = @microposts.paginate(page: params[:page])
    render 'show_liked'
  end

  def edit_status
    respond_to do |format|
      format.js {}
    end
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params()
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :status)
    end

    # Before filters

    def unsigned_in_user
      if signed_in?
        redirect_to root_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
