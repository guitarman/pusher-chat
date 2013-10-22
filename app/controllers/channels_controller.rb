class ChannelsController < ApplicationController
  respond_to :json

  def create
    respond_with Channel.find_or_create_by(permitted_params)
  end

  def create_subscriptions
    channel = Channel.find_by(name: params[:channelName])
    logger.error params[:subscribers].class
    params[:subscribers].each do |subscriber_id|
      subscriber = User.find(subscriber_id)
      logger.error Subscription.new(channel: channel, user: subscriber).to_yaml
    end

    render text: 'ok', status: 200
  end

  private

  def permitted_params
    params[:channel].permit(:name)
  end
end