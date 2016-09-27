enableDestroy      = require 'server-destroy'
octobluExpress     = require 'express-octoblu'
MeshbluAuth        = require 'express-meshblu-auth'
Router             = require './router'
GroundhogDayService = require './services/groundhog-day-service'
debug              = require('debug')('groundhog-day-service:server')

class Server
  constructor: ({@logFn, @disableLogging, @port, @meshbluConfig})->
    throw new Error 'Missing meshbluConfig' unless @meshbluConfig?

  address: =>
    @server.address()

  run: (callback) =>
    app = octobluExpress({ @logFn, @disableLogging })

    meshbluAuth = new MeshbluAuth @meshbluConfig
    app.use meshbluAuth.auth()
    app.use meshbluAuth.gateway()

    groundhogDayService = new GroundhogDayService
    router = new Router {@meshbluConfig, groundhogDayService}

    router.route app

    @server = app.listen @port, callback
    enableDestroy @server

  stop: (callback) =>
    @server.close callback

  destroy: =>
    @server.destroy()

module.exports = Server
