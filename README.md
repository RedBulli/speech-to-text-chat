Speech to Text Chat
====================
Reuses the same backbone model file on the server and the client. Useful for validation on both sides etc.

Reuses the same Backbone models on the server and the client. Useful e.g. for reusing validation.

Uses https by default to avoid the browser asking for the permission to use microphone every time the mic goes back on.

## Get started
```bash
$ npm install # Installs dependencies & compiles coffees 
$ npm start # Starts server
```
Head to https://localhost:4001 and accept the self signed certificates

## Playing around
```bash
$ npm run-script coffee-watch # Watches the coffee-script files for changes
```
