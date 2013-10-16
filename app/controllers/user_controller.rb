class UserController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  def auth
    logger.error "auth"
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
        :user_id => 1234, # => required
        :user_info => { # => optional - for example
                        :name =>"test_name",
                        :email => "test_email"
        }
    })
    logger.error "response" + response.to_s
    render :json => response
  end
end