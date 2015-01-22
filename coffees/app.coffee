define ['./public/js/models.js'], (Models) ->
  connections = 0

  initialize: (socketio) ->
    socketio.sockets.on 'connection', (socket)  ->
      connections++
      nickname = "User##{connections}"

      socketio.sockets.emit 'textModel',
        date: new Date(),
        nickname: nickname,
        text: "--- Joined the chat ---"

      socket.on 'msg', (text) ->
        textModel = new Models.Message
          date: new Date(),
          nickname: nickname,
          text: text
        socketio.sockets.emit 'textModel', textModel
