define(['backbone', 'handlebars'],
  (Backbone, Handlebars) ->
    class Views
    class Views.TextView extends Backbone.View
      initialize: () ->
        this.template = Handlebars.compile($('#text-template').html());
      render: () ->
        this.$el.html(this.template(this.model.toJSON()))

    class Views.TextsView extends Backbone.View
      initialize: () ->
        _.bindAll(this, 'render');
        this.collection.on('add', this.render)
      render: () ->
        listElement = this.$el
        #TODO Show only last 50
        $('#errors').html('')
        listElement.empty()
        this.collection.each((textModel) ->
          element = $('<li></li>')
          listElement.append(element)
          textView = new Views.TextView({el: element, model: textModel}).render()
        )
      renderError: (error) ->
        $('#errors').html(error)
    Views
)
