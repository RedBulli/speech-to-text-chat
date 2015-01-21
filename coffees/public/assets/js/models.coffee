define ['backbone'], (Backbone) ->
  class Models

  class Models.Message extends Backbone.Model
    validate: (attrs, options) ->

    parse: (data, options) ->
      if typeof data.date == "string"
        data.date = new Date(data.date)
      data

  class Models.Messages extends Backbone.Collection
    model: Messages
    comparator: (text) ->
      -text.get('date')

  Models
