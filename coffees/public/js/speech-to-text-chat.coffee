define ['jquery', 'underscore', 'models', 'views', 'recognition'], ($, _, Models, Views, recognition) ->
  ->
    messages = new Models.Messages()
    textsView = new Views.MessagesView(el: '#messages', collection: messages)
    messages.add(new Models.Message(
      date: new Date(),
      nickname: "",
      text: " -- Welcome to Speech to Text Chat. Works only with new Chrome browsers. Speak English. --"
    ))
    socketio = io.connect(window.location.origin)
    socketio.on 'textModel', (textModel) ->
      messages.add(new Models.Message(textModel, parse: true))

    recognition.addEventListener 'finalResult', (event) ->
      socketio.emit 'msg', event.detail

    recognition.addEventListener 'audioend', ->
      setMicColor("green")

    recognition.addEventListener 'speechstart', ->
      displaySound()

    recognition.addEventListener 'speechend', ->
      hideSound()

    setMicColor = (color) ->
      layer = document.getElementById("mic").contentDocument.getElementById("layer1")
      layer.setAttribute("stroke", color)
      layer.setAttribute("fill", color)

    getSoundEl = ->
      document.getElementById("sound").contentDocument.getElementById("main")

    displaySound = ->
      getSoundEl().setAttribute("fill", "red")

    hideSound = ->
      getSoundEl().setAttribute("fill", "none")

    $('#pressToggle').mousedown ->
      recognition.start()
      setMicColor("red")

    textsView.render()
    $('#loading').remove()
    $('#application').show()
