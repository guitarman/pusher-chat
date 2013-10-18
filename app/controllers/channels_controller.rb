class ChannelsController < ApplicationController
  respond_to :json

  def create
    respond_with Channel.find_or_create_by(permitted_params)
  end

  private

  def permitted_params
    params[:channel].permit(:name)
  end
end