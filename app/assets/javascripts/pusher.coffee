#$(document).ready =>
#  Pusher.log = (message) ->
#    if (window.console && window.console.log)
#      window.console.log(message)
#
#  pusher = new Pusher('MY_APP_ID', { authEndpoint: '/auth' })
#
#  $(".sign-in").click (e) ->
#    presenceChannel = pusher.subscribe('presence-test-channel')
#    presenceChannel.bind 'pusher:member_added', (member) ->
#      $(".chat-list").append(member.info.name + "<br>")
#    presenceChannel.bind 'my_event', (data) ->
#      alert data.message
#
#    $(this).replaceWith("<div>you are signed in</div>")

