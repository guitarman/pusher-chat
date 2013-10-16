class UserController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  def auth
    logger.error "auth"
    id = Random.rand(1000)
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
        :user_id => id, # => required
        :user_info => { # => optional - for example
                        :name =>"test_name-#{id}",
                        :email => "test_email@#{id}"
        }
    })
    logger.error "response" + response.to_s
    render :json => response
  end
end