class MessagesController < ApplicationController
  include PusherHelper
  respond_to :json

  def index
    respond_with Message.all
  end

  def show
    message = Message.find(params[:id])

    #only my message is viewed
    message.read_message(current_user.id)

    respond_with message
  end

  def create
    message = Message.new(permitted_params)

    if permitted_params[:event_type] == "chat-invitation"
      message.channel = Channel.find_or_create_by(name: permitted_params[:channel_name])
      message.sender = current_user

      message.save
    elsif permitted_params[:event_type] == "message"
      message.channel = Channel.find_or_create_by(name: permitted_params[:channel_name])
      message.sender = current_user

      message.users = message.channel.users
      message.save
    end

    send_to_channel(message)

    respond_with message
  end

  private

  def permitted_params
    params[:message].permit(:body, :event_type, :channel_name)
  end
end