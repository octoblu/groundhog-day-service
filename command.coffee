colors   = require 'colors'
dashdash = require 'dashdash'

Server      = require './src/server'
packageJSON = require './package.json'

OPTIONS = [{
  names: ['disable-logging', 'd']
  type: 'bool'
  help: 'Disable Logging'
  env: 'DISABLE_LOGGING'
}, {
  names: ['help', 'h']
  type: 'bool'
  help: 'Print this help and exit.'
}, {
  names: ['port', 'p']
  type: 'integer'
  help: 'Port to listen to'
  env:  'PORT'
}, {
  names: ['version', 'v']
  type: 'bool'
  help: 'Print the version and exit.'
}]

class Command
  constructor: ({@argv}) ->
    throw new Error 'Missing required parameter: argv' unless @argv?
    process.on 'uncaughtException', @die
    {@port, @disableLogging} = @parseOptions()

  die: (error) =>
    console.error error.stack
    process.exit 1

  parseOptions: =>
    parser  = dashdash.createParser({options: OPTIONS})
    options = parser.parse @argv

    if options.help
      console.log @usage parser.help({includeEnv: true})
      process.exit 0

    if options.version
      console.log packageJSON.version
      process.exit 0

    {port, disable_logging} = options
    unless port?
      console.error @usage parser.help({includeEnv: true})
      console.error colors.red 'Missing one of: -p, --port, PORT' unless port?
      process.exit 1

    return {port, disableLogging: !!disable_logging}

  run: =>
    server = new Server {@disableLogging, @port}
    server.run (error) =>
      return @die error if error?
      console.log "GroundhogDayService listening on port: #{server.address().port}"

    process.on 'SIGTERM', =>
      console.log 'SIGTERM caught, exiting'
      server.stop =>
        process.exit 0

  usage: (optionsStr) =>
    return """
      usage: node command.js [options]

      options:
      #{optionsStr}
    """

module.exports = Command
