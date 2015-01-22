define ['./public/assets/js/models.js'], (Models) ->
  connections = 0

  initialize: (socketio) ->
    socketio.sockets.on 'connection', (socket)  ->
      connections++
      nickname = "User##{connections}"

      socketio.sockets.emit 'textModel',
        date: new Date(),
        nickname: null,
        text: "New user: #{nickname}"

      socket.on 'msg', (text) ->
        textModel = new Models.Message
          date: new Date(),
          nickname: nickname,
          text: text
        socketio.sockets.emit 'textModel', textModel
