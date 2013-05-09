define(['./backbone-sync.js', 'backbone'],
  (sync, Backbone) ->
    Backbone.sync = sync
    class Models

    class Models.TextModel extends Backbone.Model
      validate: (attrs, options) ->
        return

    class Models.TextsModel extends Backbone.Collection
      model: Models.TextsModel
      comparator: (textModel) ->
        -textModel.get('date')
    Models
)
