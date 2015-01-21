define ['fs', 'https', 'pem'], (fs, https, pem) ->
  keyFile = 'example-server.key'
  certFile = 'example-server.crt'

  getCertificates = (callback) ->
    fs.readFile keyFile, encoding: 'utf8', (keyErr, key) ->
      fs.readFile certFile, encoding: 'utf8', (certErr, cert) ->
        if !(keyErr || certErr) && key && cert
          callback(key: key, cert: cert)
        else
          generateCertificates (generatedKeys) ->
            writeKeys(generatedKeys)
            callback
              key: generatedKeys.serviceKey,
              cert: generatedKeys.certificate

  writeKeys = (keys) ->
    try
      fs.writeFileSync(keyFile, keys.serviceKey)
      fs.writeFileSync(certFile, keys.certificate)

  generateCertificates = (callback) ->
    pem.createCertificate { days: 10000, selfSigned: true }, (err, keys) ->
      throw err if err
      callback(keys)

  listen = (port, processRequest, callback) ->
    getCertificates (keys) ->
      callback(https.createServer(keys, processRequest).listen(port))

  listen: listen
