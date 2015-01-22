define ['jquery', 'underscore', 'models', 'views', 'recognition'], ($, _, Models, Views, recognition) ->
  ->
    messages = new Models.Messages()
    textsView = new Views.MessagesView(el: '#speechText', collection: messages)
    socketio = io.connect(window.location.origin)
    socketio.on 'textModel', (textModel) ->
      messages.add(new Models.Message(textModel, parse: true))

    recognition.addEventListener 'finalResult', (event) ->
      socketio.emit 'msg', event.detail

    $('#pressToggle').mousedown ->
      recognition.start()
      $('#pressToggle').attr('disabled', true)

    textsView.render()
    $('#loading').remove()
    $('#application').show()
