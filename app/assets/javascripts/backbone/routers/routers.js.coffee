class PusherChat.Router extends Backbone.Router
  routes:
    "" : "index"

  index: ->
    view = new PusherChat.Views.ChatIndexView({currentUserId: @.currentUserId, collection: new PusherChat.Collections.Channels()})
    $('#container').html(view.render().el)