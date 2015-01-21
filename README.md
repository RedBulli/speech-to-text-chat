Speech to Text Chat
====================

Testing the Chrome's webkitSpeechRecognition API. Sending messages with Socket.io and reusing the same Backbone model scripts on the server and the client with the help of RequireJS.

Uses https by default to avoid the browser asking for the permission to use microphone every time the mic goes back on.

Try it out at: [https://speech-to-text-chat.herokuapp.com/](https://speech-to-text-chat.herokuapp.com/)

## Get started
```bash
$ npm install # Installs dependencies & compiles coffees 
$ npm start https # Starts https server

# Alternatively as http server
$ npm start
```
Head to http or https://localhost:4001 (and accept the self signed certificates).

## Playing around
```bash
$ npm run-script coffee-watch # Watches the coffee-script files for changes
```
