class ChatsController < ApplicationController
  require 'will_paginate/array'
  def show
    @user = User.find(params[:id])
    @current_user = User.find(session[:user_id])
    @rooms = Room.public_rooms.order("created_at DESC").paginate(page:params[:page],per_page: 4)
    @users = User.all_except(@current_user).order("created_at DESC").paginate(page:params[:page],per_page: 4)
    @room = Room.new
    @message = Message.new
    @room_name = get_name(@user, @current_user)
    @single_room = Room.where(name: @room_name).first || Room.create_private_room([@user, @current_user], @room_name)
    @messages = @single_room.messages

    render "rooms/index"
  end

  private
  def get_name(user1, user2)
    users = [user1, user2].sort
    "private_#{users[0].id}_#{users[1].id}"
  end
end