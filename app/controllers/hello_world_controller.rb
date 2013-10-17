require 'pusher'

class HelloWorldController < ApplicationController
  include ApplicationHelper

  def hello_world
    sign_in
    Pusher.url = "MY_APP_URL"
  end

  def push_event
    Pusher['presence-test-channel'].trigger('my_event', {
        message: 'hello world'
    })
  end
end