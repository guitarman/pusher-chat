class PusherChat.Views.ChatIndex extends Backbone.View
  template: JST['backbone/templates/chat_index']

  initialize: (options) ->
    @currentUserId = options.currentUserId

  render: ->
    $(@el).html(@template())
    @subscribeToPresence()
    this

  subscribeToPresence: ->
    Pusher.log = (message) ->
      if (window.console && window.console.log)
        window.console.log(message)

    @pusher = new Pusher('MY_APP_KEY', { authEndpoint: '/auth' })

    @presenceChannel = @pusher.subscribe('presence-test-channel')
    @presenceChannel.bind 'pusher:subscription_succeeded', (members) =>
      members.each (member) => @addUserToList(member)

    @privateUserChannel = @pusher.subscribe("private-user-#{@currentUserId}")

    @privateUserChannel.bind 'pusher:subscription_succeeded', =>
      @privateUserChannel.bind 'notification', (data) => @processNotification(data)

    @presenceChannel.bind 'pusher:member_added', (member) => @addUserToList(member)
    @presenceChannel.bind 'pusher:member_removed', (member) => @removeUserFromlist(member)

  addUserToList: (member) ->
    if $("#user-#{member.id}").length == 0
      onlineUserView = new PusherChat.Views.OnlineUser(user: member)
      $('.online-users-list').append(onlineUserView.render().el)

  removeUserFromlist: (member) ->
    $("#user-#{member.id}").remove()

  processNotification: (data) ->
    console.log "do something with: #{data}"