class MessagesController < ApplicationController
  include PusherHelper
  respond_to :json

  def index
    respond_with Message.all
  end

  def create
    message = Message.create(permitted_params)

    body_array = message.body.split(',')
    send_to_channel(body_array[0], message.event_type, body_array[1])

    respond_with message
  end

  private

  def permitted_params
    params[:message].permit(:body, :event_type)
  end
end