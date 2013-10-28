class PusherController < ApplicationController
  protect_from_forgery

  def update_subscription
    web_hook = Pusher::WebHook.new(request)
    if web_hook.valid?
      web_hook.events.each do |event|
        case event["name"]
          when 'member_added'
            update_subscription_state(event, :online)
          when 'member_removed'
            update_subscription_state(event, :offline)
          else
            logger.info "unidentified event"
        end
      end
      render text: 'ok', status: 200
    else
      render text: 'invalid', status: 401
    end
  end

  private

  def update_subscription_state(event, state)
    user = User.find(event["user_id"])
    channel = Channel.find_by(name: event["channel"])

    user.update_subscription_state(channel.id, state)
  end
end