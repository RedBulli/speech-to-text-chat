requirejs = require 'requirejs'
requirejs.config
  nodeRequire: require

protocol = process.argv[2]

requirejs ['express', 'http', 'fs', 'socket.io', './app.js', 'https', './get-own-certs'], 
  (express, http, fs, socketIO, application, https, getOwnCertificates) ->
    getServer = (callback) ->
      if protocol == 'https'
        getOwnCertificates (keys) ->
          callback(https.Server(keys, app))
      else
        callback(http.Server(app))

    app = express()
    app.use(express.static(__dirname + '/public'))

    getServer (httpServer) ->
      io = socketIO(httpServer)
      application.initialize(io)
      httpServer.listen(process.env.PORT || 4001)
