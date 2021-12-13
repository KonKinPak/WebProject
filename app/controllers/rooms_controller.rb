class RoomsController < ApplicationController
  require 'will_paginate/array'
  include MainConcern
  before_action :is_logged_in, only: %i[ index create show]
  def index
    @room = Room.new
    @current_user = User.find(session[:user_id])
    @rooms = Room.public_rooms.order("created_at DESC").paginate(page:params[:page],per_page: 4)
    @users = User.all_except(@current_user).order("created_at DESC").paginate(page:params[:page],per_page: 4)
  end
  
  def create
    @room = Room.create(name: params["room"]["name"])
  end

  def show
    @current_user = User.find(session[:user_id])
    @single_room = Room.find(params[:id])
    @rooms = Room.public_rooms.order("created_at DESC").paginate(page:params[:page],per_page: 4)
    @users = User.all_except(@current_user).order("created_at DESC").paginate(page:params[:page],per_page: 4)
    @room = Room.new
    @message = Message.new
    @messages = @single_room.messages
    render "index"
  end

  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:room).permit(:name,:page)
    end
end


