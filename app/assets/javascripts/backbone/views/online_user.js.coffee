class PusherChat.Views.OnlineUser extends Backbone.View
  template: JST['backbone/templates/online_user']

  render: ->
    console.log this.options.user.info.name
    $(@el).html(@template({attributes: this.options.user}))
    this