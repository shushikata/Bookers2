class BooksController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_book, only: [:edit, :update]

  def index
    @books = Book.all
    @books = Book.page(params[:page]).per(6)
    @book = Book.new
    @user = current_user
  end

  def create 
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save 
      flash[:notice] = "You have creatad book successfully."
      redirect_to book_path(@book)
    else 
      @books = Book.all
      @books = Book.page(params[:page]).per(6)
      @user = current_user
      render 'index'
    end
  end

  def show
    @book = Book.find(params[:id])
    @books = Book.new
    @user = @book.user
    @comment = Comment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update 
    @book = Book.find(params[:id])
    if @book.update(book_params) 
      flash[:notice] = "You have update book successfully."
      redirect_to book_path(@book)
    else  
      render 'edit'
    end
  end

  def destroy 
    book = Book.find(params[:id])
    book.destroy 
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def correct_book
    book = Book.find(params[:id])
    redirect_to books_path if current_user.id != book.user_id 
  end
end
