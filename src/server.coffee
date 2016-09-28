enableDestroy       = require 'server-destroy'
octobluExpress      = require 'express-octoblu'
Router              = require './router'

class Server
  constructor: ({@logFn, @disableLogging, @port})->

  address: =>
    @server.address()

  run: (callback) =>
    app = octobluExpress({ @logFn, @disableLogging })
    router = new Router
    router.route app

    @server = app.listen @port, callback
    enableDestroy @server

  stop: (callback) =>
    @server.close callback

  destroy: (done) =>
    @server.destroy(done)

module.exports = Server
