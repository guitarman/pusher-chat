class ChannelsController < ApplicationController
  include ApplicationHelper
  respond_to :json

  def create
    respond_with Channel.find_or_create_by(permitted_params)
  end

  def create_subscriptions
    channel = Channel.find_by(name: params[:channelName])
    params[:subscribers].each do |subscriber_id|
      subscriber = User.find(subscriber_id)
      Subscription.find_or_create_by(channel: channel, user: subscriber)
    end

    render text: 'ok', status: 200
  end

  def current_user_subscriptions
    @channels = current_user.channels
    respond_with @channels
  end

  private

  def permitted_params
    params[:channel].permit(:name)
  end
end