class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_user, only:[:edit, :update]

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      UserNotifierMailer.send_signup_email(@user).deliver
      redirect_to @user
    else
      render "homes/top"
    end
  end

  def index
    @users = User.all
    @user = current_user
    @book = Book.new
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update 
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
      flash[:notice] = 'You have updated user successfully.'
    else
      @users = User.all
      render 'edit'
    end
  end

  def follows
    user = User.find(params[:id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :address_city, :address_street, :prefecture_code)
  end

  def correct_user
    user = User.find(params[:id])
    redirect_to user_path(current_user) if current_user != user
  end
end
