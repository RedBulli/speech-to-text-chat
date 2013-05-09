define(['./public/assets/js/models.js'], (models) ->
  texts = new models.TextsModel()
  connections = 0

  { initialize: (socketio) ->
    socketio.sockets.on('connection', (socket)  ->
      connections++
      socket.set('nickname', connections.toString(), () ->
        socketio.sockets.emit('textModel', {date: new Date(), nickname: null, text: 'New user: ' + connections.toString()})
      )
      socket.on('msg', (text) ->
        socket.get('nickname', (err, name) ->
          textModel = new models.TextModel({date: new Date(), nickname: name, text: text})
          texts.add(textModel)
          socketio.sockets.emit('textModel', textModel)
        )
      )
    )
  }
)
