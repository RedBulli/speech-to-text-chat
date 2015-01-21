requirejs.config
  paths:
    jquery: '/assets/js/lib/jquery/dist/jquery'
    underscore: '/assets/js/lib/underscore-amd/underscore'
    backbone: '/assets/js/lib/backbone-amd/backbone'
    handlebars: '/assets/js/lib/handlebars/handlebars'
  shim:
    handlebars:
      exports: 'Handlebars'

requirejs ['jquery', 'underscore', './assets/js/models.js', './assets/js/views.js'],
  ($, _, Models, Views) ->
    socketio = io.connect(window.location.origin)
    messages = new Models.Messages()
    socketio.on 'textModel', (textModel) ->
      messages.add(new Models.Message(textModel, parse: true))

    recognition = new webkitSpeechRecognition()
    recognition.interimResults = false
    recognition.lang = 'en-US'
    recognition.onresult = (event)  ->
      socketio.emit 'msg', event.results[event.resultIndex][0].transcript
      false
    recognition.onaudiostart = (event) ->
      $('#audioStatus .value').html('Mic is on!')
    recognition.onaudioend = (event) ->
      $('#audioStatus .value').html('Mic is off!')
      stopRecognition()
    recognition.onsoundstart = (event) ->
      $('#soundStatus .value').html('Hearing sounds!')
    recognition.onsoundend = (event) ->
      $('#soundStatus .value').html('No sounds coming!')
    recognition.onspeechstart = (event) ->
      $('#speechStatus .value').html('Hearing speech!')
    recognition.onspeechend = (event) ->
      $('#speechStatus .value').html('No speech coming!')

    resetButtons = ->
      $('#continuousToggle').html('Continuous recording').removeAttr('disabled')
      $('#pressToggle').html('Hold pressed to speak').removeAttr('disabled')

    stopRecognition = ->
      recognition.stop()
      recognition.continuous = false
      resetButtons()

    stopContinuousRecognition = ->
      recognition.continuous = false
      stopRecognition()

    startContinuousRecognition = ->
      recognition.continuous = true
      recognition.start()
      $('#continuousToggle').html('Stop continuous recording')
      $('#pressToggle').attr('disabled', 'disabled')

    bindUiEvents = ->
      $('#continuousToggle').click ->
        if recognition.continuous
          stopContinuousRecognition()
        else
          startContinuousRecognition()

      $('#pressToggle').mousedown ->
          recognition.start()
          $('#continuousToggle').attr('disabled', 'disabled')
          $('#pressToggle').html('Release to analyze speech')

      $('#pressToggle').mouseup ->
        stopRecognition()

    startApp = ->
      textsView = new Views.MessagesView(el: '#speechText', collection: messages)
      textsView.render()
      bindUiEvents()
      $('#application').show()
      $('#loading').remove()
      resetButtons()

    $(document).ready(startApp)
