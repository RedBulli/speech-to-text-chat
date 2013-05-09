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
    recognition.continuous = true
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
      $('#micToggle').html('Stop!')
    recognition.onend = (event)  -> 
      recStatus = false
      $('#micToggle').html('Start chatting!')
    $.ready(
      $('#micToggle').click () ->
        if recStatus == false
          recognition.start()
        else
          recognition.stop()
    )
)
