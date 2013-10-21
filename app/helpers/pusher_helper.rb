require 'pusher'
module PusherHelper
  include ApplicationHelper

  def initialize_pusher
    Pusher.url = "MY_APP_URL"
  end

  def send_to_channel(message)
    Pusher[message.channel_name].trigger(message.event_type, {
      message: message.id
    })
  end
end
