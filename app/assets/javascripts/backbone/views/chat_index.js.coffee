class PusherChat.Views.ChatIndexView extends Backbone.View
  template: JST['backbone/templates/chat_index']

  initialize: (options) ->
    @currentUserId = options.currentUserId
    @pusher = new Pusher('MY_APP_ID', { authEndpoint: '/auth' })
    @collection.on('add', @initializeChat, this)

  events:
    'click .offline-users-list ul li': 'startChat'
    'click .online-users-list ul li': 'startChat'

  render: ->
    $(@el).html(@template())
    @connectToPusher()
    this

  connectToPusher: ->
    Pusher.log = (message) ->
      if (window.console && window.console.log)
        window.console.log(message)

    @subscribeToPresenceChannel('presence-test-channel')
    @subscribeToPrivateChannel("private-user-#{@currentUserId}")

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

  subscribeToPrivateChannel: (privateChannelName) ->
    privateUserChannel = @pusher.subscribe(privateChannelName)
    privateUserChannel.bind 'pusher:subscription_succeeded', =>
      privateUserChannel.bind 'chat-invitation', (data) => @processNotification(data)

    @saveChannel(privateChannelName)

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


  saveChannel: (channelName, recipient_ids = null) ->
    attributes = name: channelName, recipient_ids: recipient_ids
    @collection.create attributes,
      success: -> console.log "Channel was saved"
      error: -> console.log "Channel was not saved"

  startChat: (event) ->
    event.preventDefault()
    targetUserId = event.target.id.replace("user-", "")

    presenceConvChannelName = "presence-#{@currentUserId}-#{targetUserId}"
    @saveChannel(presenceConvChannelName, [targetUserId, @currentUserId])

  initializeChat: (model) ->
    #save subscriptions
    console.log "saving subscriptions", model.attributes
    if (model.attributes.recipient_ids != null)
      $.ajax(
        type: "POST"
        url: "channels/create_subscriptions"
        dataType: 'json'
        data: {subscribers: model.attributes.recipient_ids, channelName: model.attributes.name}
      ).complete (data) =>
        attributes =
          event_type: 'chat-invitation'
          body: "#{model.attributes.name}"
          channel_name: "private-user-#{model.attributes.recipient_ids[0]}"

        message = new PusherChat.Models.Message()
        message.save attributes,
          success: =>
            console.log "Message sent"
          error: -> console.log "Message was not sent"


  processNotification: (data) ->
    console.log "your new message ", data

#        privateConversationChannel = @pusher.subscribe(channelName)
#        privateConversationChannel.bind 'pusher:subscription_succeeded', =>
#          privateConversationChannel.bind 'message', (data) => @processMessage(data)
#          chatWindowView = new PusherChat.Views.ChatWindowView({channelName: privateConvChannelName, targetUserName: event.target.innerText})
#          $('.chat-windows').append(chatWindowView.render().el)
#
#
#
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