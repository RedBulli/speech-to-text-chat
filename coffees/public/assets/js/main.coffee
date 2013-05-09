requirejs.config({
  paths: {
    'jquery': '/assets/js/lib/jquery',
    'underscore': '/assets/js/lib/underscore',
    'backbone': '/assets/js/lib/backbone',
    'bacon': '/assets/js/lib/Bacon',
    'handlebars': '/assets/js/lib/handlebars',
  },
  shim: {
    'handlebars': {
      exports: 'Handlebars'
    }
  }
})
requirejs(['jquery', 'bacon', './assets/js/models.js', './assets/js/views.js'],
  ($, Bacon, Models, Views) ->
    $.fn.asEventStream = Bacon.$.asEventStream;
    socketio = io.connect(window.location.origin)
    window.socketio = socketio
    textsModel = new Models.TextsModel()
    socketio.on 'textModel', (textModel) -> 
      textModel.date = new Date(Date.parse(textModel.date))
      textsModel.add(new Models.TextModel(textModel))
    textsView = new Views.TextsView({el: '#speechText', collection: textsModel})
    textsView.render()

    recStatus = false
    recognition = new webkitSpeechRecognition()
    recognition.interimResults = false
    recognition.lang = 'fi-FI'
    recognition.onresult = (event)  -> 
      final_transcript = ''
      for i in [event.resultIndex...event.results.length]
        final_transcript += event.results[i][0].transcript;
      socketio.emit('msg', final_transcript)
      return false
    recognition.onstart = (event) ->
      recStatus = true
    recognition.onend = (event)  -> 
      recStatus = false
      recognition.continuous = false
      resetUi()
    recognition.onaudiostart = (event) ->
      $('#audioStatus .value').html('Mic is on!')
    recognition.onaudioend = (event) ->
      $('#audioStatus .value').html('Mic is off!')
    recognition.onsoundstart = (event) ->
      $('#soundStatus .value').html('Hearing sounds!')
    recognition.onsoundend = (event) ->
      $('#soundStatus .value').html('No sounds coming!')
    recognition.onspeechstart = (event) ->
      $('#speechStatus .value').html('Hearing speech!')
    recognition.onspeechend = (event) ->
      $('#speechStatus .value').html('No speech coming!')

    resetUi = () ->
      $('#continuousToggle').html('Continuous recording').removeAttr('disabled')
      $('#pressToggle').html('Hold pressed to speak').removeAttr('disabled')

    $.ready(
      $('#application').show()
      $('#loading').remove()
      resetUi()
      $('#continuousToggle').click () ->
        recognition.continuous = true
        if recStatus == false
          recognition.start()
          $('#continuousToggle').html('Stop continuous recording')
          $('#pressToggle').attr('disabled', 'disabled')
        else
          recognition.stop()
      $('#pressToggle').mousedown () ->
        if recStatus == false
          recognition.start()
          $('#continuousToggle').attr('disabled', 'disabled')
          $('#pressToggle').html('Release to analyze speech')
      $('#pressToggle').mouseup () ->
        if recStatus == true
          recognition.stop()
    )
)


