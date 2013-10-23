class PusherChat.Models.Channel extends Backbone.Model
  defaults:
    recipient_ids: []

  url: ->
    return "/channels"

class PusherChat.Collections.Channels extends Backbone.Collection
  model: PusherChat.Models.Channel