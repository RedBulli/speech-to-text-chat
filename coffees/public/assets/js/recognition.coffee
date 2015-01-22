define ['jquery'], ($) ->
  setAudioStatus = (text) -> $('#audioStatus .value').html text
  setSoundStatus = (text) -> $('#soundStatus .value').html text
  setSpeechStatus = (text) -> $('#speechStatus .value').html text

  recognition = new webkitSpeechRecognition()
  recognition.interimResults = false
  recognition.lang = 'en-US'

  getResult = (event) ->
    event.results[event.resultIndex][0].transcript

  recognition.onresult = (event) ->
    recognition.dispatchEvent(new CustomEvent('finalResult', detail: getResult(event)))
    false
  recognition.onaudiostart = -> setAudioStatus('Mic is on!')
  recognition.onaudioend = ->
    setAudioStatus('Mic is off!')
    recognition.stop()
    $('#pressToggle').removeAttr('disabled')

  recognition.onsoundstart = -> setSoundStatus 'Hearing sounds!'
  recognition.onsoundend = -> setSoundStatus 'No sounds coming!'
  recognition.onspeechstart = -> setSpeechStatus 'Hearing speech!'
  recognition.onspeechend = -> setSpeechStatus 'No speech coming!'
  recognition
