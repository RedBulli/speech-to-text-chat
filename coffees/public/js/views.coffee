define ['backbone', 'handlebars'], (Backbone, Handlebars) ->
  class Views
  class Views.MessageView extends Backbone.View
    initialize: ->
      @template = Handlebars.compile($('#message-template').html())

    toViewModel: ->
      date: @model.get('date').toLocaleTimeString(),
      nickname: @model.get('nickname'),
      text: @model.get('text')

    render: ->
      @$el.html(@template(@toViewModel()))

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
