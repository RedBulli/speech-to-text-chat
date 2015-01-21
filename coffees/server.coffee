requirejs = require 'requirejs'
requirejs.config
  nodeRequire: require

protocol = process.argv[2] || 'https'
port = process.env.PORT || 4001
cache = process.env.CACHE
if cache == undefined
  cache = false

requirejs ['fs', 'node-static', 'socket.io', './app.js', './https_server', 'http'], 
  (fs, staticServer, io, application, httpsServer, http) ->
    file = new (staticServer.Server)('./public', cache: cache)

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

    server.listen port, processRequest, (listeningServer) ->
      exports.socketio = io.listen(listeningServer)
      application.initialize(exports.socketio)
