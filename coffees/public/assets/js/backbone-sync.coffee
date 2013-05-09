define () ->
  root = exports ? this

  return (method, model, options) ->
    if root.socketio != null
      root.socketio.on 'object', (data) -> 
        model.set(data.model)
      root.socketio.emit('object', {
        method: method, model: model, type: model.type
      })
