class PusherChat.Router extends Backbone.Router
  routes:
    "" : "index"

  index: ->
    view = new PusherChat.Views.ChatIndex()
    $('#container').html(view.render().el)