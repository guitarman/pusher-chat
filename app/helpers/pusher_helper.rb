require 'pusher'
module PusherHelper
  include ApplicationHelper

  def initialize_pusher
    Pusher.url = "MY_APP_URL"
  end

  def send_to_channel(target_channel_name, event_type, message)
    Pusher[target_channel_name].trigger(event_type, {
        message: message,
        from: current_user.id,
        fromName: current_user.name
    })
  end
end
