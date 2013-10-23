class PusherChat.Views.ChatWindowView extends Backbone.View
  template: JST['backbone/templates/chat_window']

  initialize: (options) ->
    @channelName = options.channelName

  events:
    "submit": 'sendMessage'

  render: ->
    $(@el).html(@template({channelName: @channelName}))
    this

  sendMessage: (event) ->
    event.preventDefault()
    messageText = $("##{@channelName}-message").val()
    attributes = event_type: 'message', body: "#{messageText}", channel_name: "#{@channelName}"

    message = new PusherChat.Models.Message()
    message.save attributes,
      success: =>
        console.log "Message sent"
        $("##{@channelName}-message").val('')
      error: -> console.log "Message was not sent"
