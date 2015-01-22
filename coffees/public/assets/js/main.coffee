requirejs.config
  paths:
    jquery: '/assets/js/lib/jquery/dist/jquery'
    underscore: '/assets/js/lib/underscore-amd/underscore'
    backbone: '/assets/js/lib/backbone-amd/backbone'
    handlebars: '/assets/js/lib/handlebars/handlebars'
    models: '/assets/js/models'
    views: '/assets/js/views'
    speechToTextChat: '/assets/js/speech-to-text-chat'
    recognition: '/assets/js/recognition'
  shim:
    handlebars:
      exports: 'Handlebars'

requirejs ['jquery', 'speechToTextChat'], ($, chat) ->
  $(document).ready ->
    if window['webkitSpeechRecognition']
      chat()
    else
      $('#loading').html("Your browser doesn't support speech recognition. Too bad.")
