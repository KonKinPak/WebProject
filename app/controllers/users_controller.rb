class UsersController < ApplicationController
  require 'will_paginate/array'
  include MainConcern
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :is_logged_in, only: %i[ index]
  before_action :is_admin, only: %i[index]

  def main
    session[:user_id] = nil
    session[:post_id] = nil
  end

  def login
    @username = params[:username]
    @pass = params[:password]
    @user = User.find_by(username:@username)
    respond_to do |format|
      unless(@user.present? && @user.authenticate(@pass))
        format.html { redirect_to main_path , alert: "Username/password not valid" }
      else
        if(@user.status == 0)
          format.html { redirect_to main_path , alert: "Please wait approval" }
        elsif(@user.status == -1)
          format.html { redirect_to main_path , alert: "This account was banned. Plase contact admin" }
        end
        session[:user_id] = @user.id
        format.html{ redirect_to feed_path, alert: "Login successfully"}
      end
    end
  end

  def feed
    session[:post_id] = nil
    @posts = Post.all.order("created_at DESC").paginate(page:params[:page],per_page: 5)
    if(session[:user_id])
      #Login
      @user = User.find(session[:user_id])
      @posts_follow = @user.get_feed_post.paginate(page:params[:page],per_page: 5)
      respond_to do |format|
        format.html
        format.js
      end  
    else
      respond_to do |format|
        format.html
        format.js
      end      
    end
  end

  def profile
    if(session[:user_id])
      @self_user = User.find(session[:user_id])
    end
    @user = User.find_by(nickname:params[:nickname])
    #not found user
    unless(@user.present?)
      redirect_to feed_path ,alert: "Could not find this user."
      return
    else
    #found user
      if(@user.status == 0)
        redirect_to request.referrer, alert: "This user was not approved yet." 
      elsif(@user.status == -1)
        redirect_to request.referrer , alert: "This account was banned. Plase contact admin"
      end
      @posts = @user.posts.order("created_at DESC").paginate(page:params[:page],per_page: 5)
    end
  end

  def follow
    profile_user = User.find_by(nickname:params[:nickname])
    Follow.create(follower_id:session[:user_id],followee_id:profile_user.id)
    if(request.referrer)
      redirect_to request.referrer ,notice: "You just follow " + profile_user.nickname
    end
  end

  def unfollow
    profile_user = User.find_by(nickname:params[:nickname])
    Follow.find_by(follower_id:session[:user_id],followee_id:profile_user.id).destroy
    if(request.referrer)
      redirect_to request.referrer  ,notice: "You just unfollow " + profile_user.nickname
    end
  end

  def index
    @users = User.all
  end

  def approve
    @user = User.find(params[:id].to_i)
    console(@user.nickname)
    @user.update_attribute(:status,1)
    redirect_to users_path, notice: 'User was successfully updated.'
  end

  def ban
    @user = User.find(params[:id].to_i)
    console(@user.nickname)
    @user.update_attribute(:status,-1)
    redirect_to users_path, notice: 'User was successfully updated.'
  end

  def unban
    @user = User.find(params[:id].to_i)
    console(@user.nickname)
    @user.update_attribute(:status,1)
    redirect_to users_path, notice: 'User was successfully updated.'
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    is_right_user(params[:id].to_i)
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :nickname, :password, :password_confirmation,:page,:avatar)
    end
end
