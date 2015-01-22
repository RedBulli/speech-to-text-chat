requirejs.config
  baseUrl: 'js'
  paths:
    jquery: '/js/lib/jquery/dist/jquery'
    underscore: '/js/lib/underscore-amd/underscore'
    backbone: '/js/lib/backbone-amd/backbone'
    handlebars: '/js/lib/handlebars/handlebars'
  shim:
    handlebars:
      exports: 'Handlebars'

requirejs ['jquery', 'speech-to-text-chat'], ($, chat) ->
  $(document).ready ->
    if window['webkitSpeechRecognition']
      chat()
    else
      $('#loading').html("Your browser doesn't support speech recognition. Too bad.")
