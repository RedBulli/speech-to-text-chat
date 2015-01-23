requirejs.config
  baseUrl: 'js'
  paths:
    jquery: '/js/lib/jquery/dist/jquery.min'
    underscore: '/js/lib/underscore-amd/underscore-min'
    backbone: '/js/lib/backbone-amd/backbone-min'

requirejs ['jquery', 'speech-to-text-chat'], ($, chat) ->
  $(document).ready ->
    if window['webkitSpeechRecognition']
      chat()
    else
      $('#loading').html("Your browser doesn't support speech recognition. Too bad.")
