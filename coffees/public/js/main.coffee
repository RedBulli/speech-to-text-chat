requirejs.config
  paths:
    jquery: '/js/lib/jquery/dist/jquery'
    underscore: '/js/lib/underscore-amd/underscore'
    backbone: '/js/lib/backbone-amd/backbone'
    handlebars: '/js/lib/handlebars/handlebars'
    models: '/js/models'
    views: '/js/views'
    speechToTextChat: '/js/speech-to-text-chat'
    recognition: '/js/recognition'
  shim:
    handlebars:
      exports: 'Handlebars'

requirejs ['jquery', 'speechToTextChat'], ($, chat) ->
  $(document).ready ->
    if window['webkitSpeechRecognition']
      chat()
    else
      $('#loading').html("Your browser doesn't support speech recognition. Too bad.")
