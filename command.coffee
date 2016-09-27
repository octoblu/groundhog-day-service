_             = require 'lodash'
MeshbluConfig = require 'meshblu-config'
Server        = require './src/server'

class Command
  constructor: ->
    @serverOptions = {
      meshbluConfig:  new MeshbluConfig().toJSON()
      port:           process.env.PORT || 80
      disableLogging: process.env.DISABLE_LOGGING == "true"
    }

  panic: (error) =>
    console.error error.stack
    process.exit 1

  run: =>
    # Use this to require env
    # @panic new Error('Missing required environment variable: ENV_NAME') if _.isEmpty @serverOptions.envName
    @panic new Error('Missing meshbluConfig') if _.isEmpty @serverOptions.meshbluConfig

    server = new Server @serverOptions
    server.run (error) =>
      return @panic error if error?

      {address,port} = server.address()
      console.log "GroundhogDayService listening on port: #{port}"

    process.on 'SIGTERM', =>
      console.log 'SIGTERM caught, exiting'
      return process.exit 0 unless server?.stop?
      server.stop =>
        process.exit 0

command = new Command()
command.run()
