define [], ->
  recognition = new webkitSpeechRecognition()
  recognition.interimResults = false
  recognition.lang = 'en-US'

  getResult = (event) ->
    event.results[event.resultIndex][0].transcript

  recognition.onresult = (event) ->
    recognition.dispatchEvent(new CustomEvent('finalResult', detail: getResult(event)))
    false
  recognition.onaudioend = -> recognition.stop()

  recognition
