class CommentsController < ApplicationController
  include MainConcern
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :is_logged_in, only: %i[index edit update destroy]
  before_action :is_admin, only: %i[index]
  # GET /comments
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  def show
    if(@comment)
      redirect_to @comment.post
    end
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  def unlike
    Like.find_by(comment_id:params[:comment_id] ,user_id:session[:user_id]).destroy
    if(request.referrer)
      redirect_to request.referrer
    end
  end

  def like
    Like.create(comment_id:params[:comment_id] ,user_id:session[:user_id])
    if(request.referrer)
      redirect_to request.referrer
    end
  end

  # POST /comments
  def create
    @comment = Comment.new(msg:comment_params["msg"],user_id:session[:user_id],post_id:session[:post_id])

    if @comment.save
      redirect_to @comment.post, notice: 'Comment was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @comment, notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    redirect_to comments_url, notice: 'Comment was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:msg, :post_id, :user_id)
    end
end
