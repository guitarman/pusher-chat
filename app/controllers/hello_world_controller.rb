require 'pusher'

class HelloWorldController < ApplicationController
  def hello_world
    Pusher.url = "MY_APP_URL"

  end

  def push_event
    Pusher['presence-test-channel'].trigger('my_event', {
        message: 'hello world'
    })
  end
end