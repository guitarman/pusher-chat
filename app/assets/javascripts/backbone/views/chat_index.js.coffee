class PusherChat.Views.ChatIndex extends Backbone.View
  template: JST['backbone/templates/chat_index']

  initialize: (options) ->
    @currentUserId = options.currentUserId

  render: ->
    $(@el).html(@template())
    @connectToPusher()
    this

  connectToPusher: ->
    Pusher.log = (message) ->
      if (window.console && window.console.log)
        window.console.log(message)

    @pusher = new Pusher('MY_APP_KEY', { authEndpoint: '/auth' })
    @subscribeToPresenceChannel('presence-test-channel')
    @subscribeToPrivateChannel("private-user-#{@currentUserId}")

  subscribeToPresenceChannel: (presenceChannelName) ->
    presenceChannel = @pusher.subscribe(presenceChannelName)
    presenceChannel.bind 'pusher:subscription_succeeded', (members) =>
      members.each (member) => @addUserToList(member)

    presenceChannel.bind 'pusher:member_added', (member) => @addUserToList(member)
    presenceChannel.bind 'pusher:member_removed', (member) => @removeUserFromlist(member)
    @saveChannel(presenceChannelName)

  subscribeToPrivateChannel: (privateChannelName) ->
    privateUserChannel = @pusher.subscribe(privateChannelName)
    privateUserChannel.bind 'pusher:subscription_succeeded', =>
      privateUserChannel.bind 'notification', (data) => @processNotification(data)

    @saveChannel(privateChannelName)

  addUserToList: (member) ->
    if $("#user-#{member.id}").length == 0
      onlineUserView = new PusherChat.Views.OnlineUser(user: member)
      $('.online-users-list').append(onlineUserView.render().el)

  removeUserFromlist: (member) ->
    $("#user-#{member.id}").remove()

  processNotification: (data) ->
    console.log "do something with: #{data}"

  saveChannel: (channelName) ->
    attributes = name: channelName
    @collection.create attributes,
      success: -> console.log "Channel was saved"
      error: -> console.log "Channel was not saved"