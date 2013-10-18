class PusherChat.Views.ChatWindowView extends Backbone.View
  template: JST['backbone/templates/chat_window']

  render: ->
    $(@el).html(@template())
    this