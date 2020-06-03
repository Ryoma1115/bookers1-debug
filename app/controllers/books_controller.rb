class BooksController < ApplicationController
  # before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :ensure_correct_user,only: [:edit, :update, :destroy]
  # GET /books
  # GET /books.json
  def index
    @books = Book.all

    @book = Book.new
    @user = User.find(current_user.id)
  end

  # GET /books/1
  # GET /books/1.json
  def show
      #bookで定義していたら投稿欄のところと重複した
    @book_detail = Book.find(params[:id])
      # 子から親を参照している
    @user = @book_detail.user
    @book = Book.new
        # コメント部分
    @book_comments = @book_detail.book_comments.all
    @book_comment = BookComment.new
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  def update
    book = Book.find(params[:id])
    if book.update(book_params)
      flash[:notice] = "You have creatad book successfully."
      redirect_to book_path(book)
    else
      @book = book
      render :edit
    end
  end

  # POST /books
  # POST /books.json
  def create
    book = Book.new(book_params)
    book.user_id = current_user.id
    if book.save
      flash[:notice] = "You have creatad book successfully."
      redirect_to book_path(book)
    else
      @book = book
      @books = Book.all
      @user = current_user
      render :index
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end


  def ensure_correct_user
    book = Book.find(params[:id])
    if book.user_id != current_user.id
      redirect_to books_path
    end
  end

  private
    # # Use callbacks to share common setup or constraints between actions.
    # def set_book
    #   @book = Book.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :body)
    end
end
