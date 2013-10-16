Pusher.log = (message) ->
  if (window.console && window.console.log)
    window.console.log(message)

pusher = new Pusher('MY_APP_ID')
channel = pusher.subscribe('pusher_test_channel')

channel.bind 'my_event', (data) ->
  alert data.message
