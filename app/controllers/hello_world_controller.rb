require 'pusher'

class HelloWorldController < ApplicationController
  def hello_world

  end

  def push_event
    Pusher.url = "MY_PUSHER_URL"

    Pusher['pusher_test_channel'].trigger('my_event', {
        message: 'hello world'
    })
  end
end