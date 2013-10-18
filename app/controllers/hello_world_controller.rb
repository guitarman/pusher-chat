class HelloWorldController < ApplicationController
  include ApplicationHelper
  include PusherHelper

  def hello_world
    sign_in
    initialize_pusher
  end

  def push_event
    Pusher['presence-test-channel'].trigger('my_event', {
        message: 'hello world'
    })
  end
end