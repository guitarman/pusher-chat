class ChannelsController < ApplicationController
  respond_to :json

  def create
    respond_with Channel.create(permitted_params)
  end

  private

  def permitted_params
    params[:channel].permit(:name)
  end
end