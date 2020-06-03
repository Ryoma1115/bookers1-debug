class BookCommentsController < ApplicationController
    def create
        @book_detail = Book.find(params[:book_id])
        @book_comment = current_user.book_comments.new(book_comment_params)
        @book_comment.book_id = @book_detail.id
      if @book_comment.save
        redirect_to(book_path(@book_detail))
      else
        @book_comments = @book_detail.book_comments.all
        @user = @book_detail.user
        @book = Book.new
        render '/books/show'
      end
    end

    def destroy
        comment = BookComment.find(params[:book_id])
    
    # 処理を書く
        if comment.user.id == current_user.id
          comment.destroy
        end
        redirect_back(fallback_location: root_path)
    end

    private
    def book_comment_params
        params.require(:book_comment).permit(:user_id, :book_id, :comment)
    end
end
