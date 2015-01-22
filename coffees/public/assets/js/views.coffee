define ['backbone', 'handlebars'], (Backbone, Handlebars) ->
  class Views
  class Views.MessageView extends Backbone.View
    initialize: ->
      @template = Handlebars.compile($('#text-template').html())

    toViewModel: ->
      date: @model.get('date').toLocaleTimeString(),
      nickname: @model.get('nickname'),
      text: @model.get('text')

    render: ->
      @$el.html(@template(@toViewModel()))

  class Views.MessagesView extends Backbone.View
    initialize: ->
      _.bindAll(@, 'render')
      @collection.on('add', @render)

    render: ->
      $('#errors').html('')
      @$el.empty()
      @collection.each (textModel) =>
        element = $('<li></li>')
        @$el.append(element)
        textView = new Views.MessageView(el: element, model: textModel).render()

    renderError: (error) ->
      $('#errors').html(error)

  Views
