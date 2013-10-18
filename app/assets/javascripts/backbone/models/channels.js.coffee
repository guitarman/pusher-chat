class PusherChat.Models.Channel extends Backbone.Model
  url: ->
    return "/channels"

class PusherChat.Collections.Channels extends Backbone.Collection
  model: PusherChat.Models.Channel