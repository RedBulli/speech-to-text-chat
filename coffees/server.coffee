requirejs = require('requirejs')
requirejs.config({
  nodeRequire: require
})

requirejs(['crypto', 'fs', 'node-static', 'https', 'http', 'socket.io', './app.js'], 
  (crypto, fs, staticServer, https, http, io, application) ->
    file = new (staticServer.Server)('./public', {cache: false})

    processRequest = (request, response) ->
      file.serve(request, response).addListener 'error', (err) ->
        file.serveFile './404.html', 404, {}, request, response
      request.addListener 'end', ->
        file.serve request, response
    httpsOptions = {
      key: fs.readFileSync('key.pem'),
      cert: fs.readFileSync('cert.pem')
    }
    httpsServer = https.createServer(httpsOptions, processRequest).listen 4000
    #httpServer = http.createServer(options, processRequest).listen 4000
    exports.socketio = io.listen(httpsServer)
    application.initialize(exports.socketio)  
)
