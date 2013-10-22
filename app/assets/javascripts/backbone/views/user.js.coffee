class PusherChat.Views.UserView extends Backbone.View

  tagName: "li"
  template: JST['backbone/templates/user']

  render: ->
    $(this.el).attr('id', "#{this.options.state}-user-#{this.options.user.id}")
    $(@el).html(@template({attributes: this.options.user}))
    this