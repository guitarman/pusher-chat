class MessagesController < ApplicationController
  respond_to :json

  def index
    respond_with Message.all
  end

  def create
    logger.error "Save message, then push it to the right channel"
    respond_with Message.create(permitted_params)
  end

  private

  def permitted_params
    params[:message].permit(:body, :event_type)
  end
end