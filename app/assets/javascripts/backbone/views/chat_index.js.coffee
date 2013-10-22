class PusherChat.Views.ChatIndexView extends Backbone.View
  template: JST['backbone/templates/chat_index']

  initialize: (options) ->
    @currentUserId = options.currentUserId
    @pusher = new Pusher('MY_APP_ID', { authEndpoint: '/auth' })

#  events:
#    'click .online-user': 'startChat'

  render: ->
    $(@el).html(@template())
    @connectToPusher()
    this

  connectToPusher: ->
    Pusher.log = (message) ->
      if (window.console && window.console.log)
        window.console.log(message)

    @subscribeToPresenceChannel('presence-test-channel')
    #@subscribeToPrivateChannel("private-user-#{@currentUserId}")

  subscribeToPresenceChannel: (presenceChannelName) ->
    presenceChannel = @pusher.subscribe(presenceChannelName)
    presenceChannel.bind 'pusher:subscription_succeeded', (members) =>
      members.each (member) => @showUserInOnlineList(member)

      #get offline users
      $.ajax(url: "/offline_users", dataType: 'json').done (data) =>
        for user in data
          @showUserInOfflineList(user)

    presenceChannel.bind 'pusher:member_added', (member) => @showUserInOnlineList(member)
    presenceChannel.bind 'pusher:member_removed', (member) => @showUserInOfflineList(member)
    @saveChannel(presenceChannelName)

#  subscribeToPrivateChannel: (privateChannelName) ->
#    privateUserChannel = @pusher.subscribe(privateChannelName)
#    privateUserChannel.bind 'pusher:subscription_succeeded', =>
#      privateUserChannel.bind 'chat-invitation', (data) => @processNotification(data)
#
#    @saveChannel(privateChannelName)

  showUserInOnlineList: (member) ->
    if (@currentUserId != member.id)
      $(".offline#user-#{member.id}").remove()
      if ($(".online#user-#{member.id}").length == 0)
        userView = new PusherChat.Views.UserView(user: member, state: "online")
        $('.online-users-list ul').append(userView.render().el)

  showUserInOfflineList: (member) ->
    if (@currentUserId != member.id)
      $(".online#user-#{member.id}").remove()
      if ($(".offline#user-#{member.id}").length == 0)
        userView = new PusherChat.Views.UserView(user: member, state: "offline")
        $('.offline-users-list ul').append(userView.render().el)

#  processNotification: (data) ->
#    #for now, automatically accept chat invitation, subscribe to channel & show new chat window
#    message = new PusherChat.Models.Message({id: data.message})
#    message.fetch
#      success: =>
#        privateConvChannelName = message.attributes.body
#        privateConversationChannel = @pusher.subscribe(privateConvChannelName)
#        privateConversationChannel.bind 'pusher:subscription_succeeded', =>
#          privateConversationChannel.bind 'message', (data) => @processMessage(data)
#          chatWindowView = new PusherChat.Views.ChatWindowView({channelName: privateConvChannelName, targetUserName: ""})
#          $('.chat-windows').append(chatWindowView.render().el)

#  processMessage: (data) =>
#    console.log "you have new message"
#    console.log data.message
#
#    message = new PusherChat.Models.Message({id: data.message})
#    message.fetch
#      success: =>
#        $("#conversation-#{message.attributes.channel_name}").append("<div><strong>:</strong> #{message.attributes.body}</div>")

  saveChannel: (channelName) ->
    attributes = name: channelName
    @collection.create attributes,
      success: -> console.log "Channel was saved"
      error: -> console.log "Channel was not saved"

#  startChat: (event) ->
#    event.preventDefault()
#    targetUserId = event.target.id.replace("user-", "")
#
#    privateConvChannelName = "private-#{@currentUserId}-#{targetUserId}"
#    attributes = event_type: 'chat-invitation', body: "#{privateConvChannelName}", channel_name: "private-user-#{targetUserId}"
#
#    message = new PusherChat.Models.Message()
#    message.save attributes,
#      success: =>
#        console.log "Message sent"
#        privateConversationChannel = @pusher.subscribe(privateConvChannelName)
#        privateConversationChannel.bind 'pusher:subscription_succeeded', =>
#          privateConversationChannel.bind 'message', (data) => @processMessage(data)
#          chatWindowView = new PusherChat.Views.ChatWindowView({channelName: privateConvChannelName, targetUserName: event.target.innerText})
#          $('.chat-windows').append(chatWindowView.render().el)
#      error: -> console.log "Message was not sent"