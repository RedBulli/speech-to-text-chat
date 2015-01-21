requirejs = require 'requirejs'
requirejs.config
  nodeRequire: require

requirejs ['fs', 'node-static', 'socket.io', './app.js', './https_server'], 
  (fs, staticServer, io, application, httpsServer) ->
    file = new (staticServer.Server)('./public', cache: false)

    processRequest = (request, response) ->
      file.serve(request, response).addListener 'error', (err) ->
        file.serveFile './404.html', 404, {}, request, response
      request.addListener 'end', ->
        file.serve request, response

    httpsServer.listen 4001, processRequest, (listeningServer) ->
      exports.socketio = io.listen(listeningServer)
      application.initialize(exports.socketio)
