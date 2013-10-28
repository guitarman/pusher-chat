class UserController < ApplicationController
  include ApplicationHelper, PusherHelper
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  def auth
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      :user_id => current_user.id,
      :user_info => {
        :name => current_user.name
      }
    })
    render :json => response
  end

  def offline_users
    users = presence_channel_users
    users_ids = users ? users[:users].map { |user| user.values }.flatten : ""

    @offline_users = User.offline_users(users_ids)
  end
end