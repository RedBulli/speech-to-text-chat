define ['backbone'], (Backbone) ->
  class Views
  class Views.MessageView extends Backbone.View
    getFormattedDate: ->
      @model.get('date').toLocaleTimeString()

    render: ->
      @$el.html("#{@getFormattedDate()} [#{@model.get('nickname')}]: #{@model.get('text')}")

  class Views.MessagesView extends Backbone.View
    render: ->
      @$el.empty()
      @collection.each (message) => @renderOne(message)
      @collection.on 'add', (message) => @renderOne(message)

    renderOne: (message) ->
      element = $('<li></li>')
      @$el.prepend(element)
      textView = new Views.MessageView(el: element, model: message).render()

  Views
