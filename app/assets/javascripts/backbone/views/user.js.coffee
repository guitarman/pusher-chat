class PusherChat.Views.UserView extends Backbone.View

  tagName: "li"
  template: JST['backbone/templates/user']

  render: ->
    $(this.el).attr('id', "user-#{this.options.user.id}")
    $(this.el).attr('class', this.options.state)
    $(@el).html(@template({attributes: this.options.user}))
    this