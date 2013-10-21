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
    message = Message.create(permitted_params)

    send_to_channel(message)

    respond_with message
  end

  private

  def permitted_params
    params[:message].permit(:body, :event_type, :channel_name)
  end
end