class UsersController < ApplicationController
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

  def create 
  
  end

  def edit
  end

  def update 
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
