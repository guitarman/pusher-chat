class MessagesController < ApplicationController
  include PusherHelper
  respond_to :json

  def index
    respond_with Message.all
  end

  def show
    respond_with Message.find(params[:id])
  end

  def create
    message = Message.new(permitted_params)

    if permitted_params[:event_type] == "chat-invitation"
      message.channel = Channel.find_or_create_by(name: permitted_params[:channel_name])
      message.sender = current_user

      logger.error message.to_yaml
      message.save
      #save to views
    end

    send_to_channel(message)

    respond_with message
  end

  private

  def permitted_params
    params[:message].permit(:body, :event_type, :channel_name)
  end
end