class PusherChat.Models.Message extends Backbone.Model
  url: ->
    return if @isNew() then "/messages" else "/messages/#{@id}"
