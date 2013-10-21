class PusherController < ApplicationController
  protect_from_forgery :except => :webhook

  def webhook
    logger.error request
    webhook = Pusher::WebHook.new(request)
    if webhook.valid?
      webhook.events.each do |event|
        case event["name"]
          when 'member_added'
            puts "Member addded: #{event["channel"]}"
          when 'member_removed'
            puts "Member removed: #{event["channel"]}"
        end
      end
      render text: 'ok', status: 200
    else
      render text: 'invalid', status: 401
    end
  end

end