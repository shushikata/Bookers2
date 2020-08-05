class CommentsController < ApplicationController

  def create 
    @book = Book.find(params[:book_id])
    comment = Comment.new(comment_params)
    comment.user_id = current_user.id 
    comment.book_id = @book.id
    comment.save
    # redirect_back(fallback_location: root_path)
  end

  def destroy
    @book = Book.find(params[:book_id])
    Comment.find_by(id: params[:id], book_id: params[:book_id]).destroy
    # redirect_to book_path(params[:book_id])
  end


  private
  
  def comment_params
    params.require(:comment).permit(:comment)
  end
  
end
