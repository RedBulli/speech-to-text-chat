requirejs = require 'requirejs'
requirejs.config
  nodeRequire: require

protocol = process.argv[2] || 'https'

requirejs ['fs', 'node-static', 'socket.io', './app.js', './https_server', 'http'], 
  (fs, staticServer, io, application, httpsServer, http) ->
    file = new (staticServer.Server)('./public', cache: false)

    processRequest = (request, response) ->
      file.serve(request, response).addListener 'error', (err) ->
        file.serveFile './404.html', 404, {}, request, response
      request.addListener 'end', ->
        file.serve request, response

    server =
      if protocol == 'http'
        listen: (port, requestProcessor, callback) ->
          callback(
            http.createServer(requestProcessor).listen(port)
          )
      else
        httpsServer

    server.listen 4001, processRequest, (listeningServer) ->
      exports.socketio = io.listen(listeningServer)
      application.initialize(exports.socketio)
