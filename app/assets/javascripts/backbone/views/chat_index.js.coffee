class PusherChat.Views.ChatIndexView extends Backbone.View
  template: JST['backbone/templates/chat_index']

  initialize: (options) ->
    @currentUserId = options.currentUserId
    @pusher = new Pusher('MY_APP_ID', { authEndpoint: '/auth' })
    @collection.on('add', @initializeChat, this)
    @openedConversations = []

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

      #get my subscriptions and listen to them
#      $.ajax(url: "/subscriptions", dataType: 'json').done (data) =>
#        for channel in data
#          conversationChannel = @pusher.subscribe(channel.name)
#          conversationChannel.bind 'pusher:subscription_succeeded', =>
#            conversationChannel.bind 'message', (data) => @readChannel(data)

      #get offline messages
      $.ajax(url: "/offline_messages", dataType: 'json').done (data) =>
        console.log "offline messages", data
        for message in data
          @processMessage(message)

    presenceChannel.bind 'pusher:member_added', (member) => @showUserInOnlineList(member)
    presenceChannel.bind 'pusher:member_removed', (member) => @showUserInOfflineList(member)
    @saveChannel(presenceChannelName)

  subscribeToPrivateChannel: (privateChannelName) ->
    privateUserChannel = @pusher.subscribe(privateChannelName)
    privateUserChannel.bind 'pusher:subscription_succeeded', =>
      privateUserChannel.bind 'chat-invitation', (data) => @readChannel(data)

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
    channel = new PusherChat.Models.Channel()
    channel.save attributes,
      success: =>
        @collection.add(channel)
        console.log "Channel was saved"
      error: -> console.log "Channel was not saved"

  startChat: (event) ->
    event.preventDefault()
    targetUserId = event.target.id.replace("user-", "")

    presenceConvChannelName = "presence-#{@currentUserId}-#{targetUserId}"
    @saveChannel(presenceConvChannelName, [targetUserId, @currentUserId])

  initializeChat: (model) ->
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
            @openConversationWindow(model.attributes.name)
            conversationChannel = @pusher.subscribe(model.attributes.name)
            conversationChannel.bind 'pusher:subscription_succeeded', =>
              conversationChannel.bind 'message', (data) => @readChannel(data)
          error: -> console.log "Message was not sent"

  readChannel: (data) =>
    message = new PusherChat.Models.Message({id: data.message})
    message.fetch
      success: =>
        @processMessage(message.attributes)

   processMessage: (message) =>
    if message.event_type == "chat-invitation"
      conversationChannel = @pusher.subscribe(message.body)
      conversationChannel.bind 'pusher:subscription_succeeded', =>
        conversationChannel.bind 'message', (data) => @readChannel(data)
    else if message.event_type == "message"
      console.log "message ", message
      @openConversationWindow(message.channel_name) unless @isConversationOpen(message.channel_name)
      $("#conversation-#{message.channel_name}").append("<div><strong>#{message.sender_name}</strong><small>[#{message.time}]</small> : #{message.body}</div>")

  isConversationOpen: (channelName) =>
    if @openedConversations.indexOf(channelName) == -1
      false
    else
      true

  openConversationWindow: (channelName) ->
    @openedConversations.push channelName
    chatWindowView = new PusherChat.Views.ChatWindowView({channelName: channelName})
    $('.chat-windows').append(chatWindowView.render().el)