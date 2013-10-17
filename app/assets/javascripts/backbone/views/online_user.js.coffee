class PusherChat.Views.OnlineUser extends Backbone.View
  template: JST['backbone/templates/online_user']

  render: ->
    $(@el).html(@template({attributes: this.options.user}))
    this