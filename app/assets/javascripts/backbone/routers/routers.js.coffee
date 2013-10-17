class PusherChat.Router extends Backbone.Router
  routes:
    "" : "index"

  index: ->
    view = new PusherChat.Views.ChatIndex({currentUserId: @.currentUserId})
    $('#container').html(view.render().el)