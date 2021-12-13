class PostsController < ApplicationController
  include MainConcern
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :is_logged_in, only: %i[index edit update destroy like unlike]
  before_action :is_admin, only: %i[index update destroy]
  before_action :is_ban ,only: %i[like unlike new edit create update]
  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    session[:post_id] = @post.id
    @comment = Comment.new
    if(session[:user_id])
      @self_user = User.find(session[:user_id])
    end
    views = @post.views+1
    @post.update(views: views)
    @user = User.find(@post.user_id)
    if(@post.comments.present?)
      @comments = @post.comments.sort().reverse
    end
  end

  def unlike
    Like.find_by(post_id:params[:post_id] ,user_id:session[:user_id]).destroy
    if(request.referrer)
      redirect_to request.referrer
    end
  end

  def like
    Like.create(post_id:params[:post_id] ,user_id:session[:user_id])
    if(request.referrer)
      redirect_to request.referrer
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    post = Post.find(params[:id].to_i)
    is_right_user(post.user_id)
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = session[:user_id]
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id].to_i)
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :description, :user_id, :body,:views,:banner)
    end
end
