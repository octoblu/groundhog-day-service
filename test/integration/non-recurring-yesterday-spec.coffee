{afterEach, beforeEach, describe, it} = global
{expect} = require 'chai'

cson    = require 'cson'
moment  = require 'moment'
path    = require 'path'
request = require 'request'
sinon   = require 'sinon'

NON_RECURRING_TODAY = cson.parseFile path.join(__dirname, '../fixtures/non-recurring-today.cson')
Server              = require '../../src/server'

describe 'non-recurring-today', ->
  beforeEach 'Go back in time to 8am MST 2016-09-28 ', =>
    sinon.useFakeTimers moment('2016-09-28T15:00:00Z').valueOf()

  afterEach 'Back to the future', =>
    sinon.restore()

  beforeEach (done) ->
    @server = new Server disableLogging: true, logFn: =>
    @server.run (error) =>
      return done error if error?
      @request = request.defaults
        baseUrl: "http://localhost:#{@server.address().port}"
        json: true
      done()

  afterEach (done) ->
    @server.destroy done

  describe 'On POST /agenda', ->
    beforeEach (done) ->
      @request.post '/agendas', body: NON_RECURRING_TODAY, (error, @response, @body) =>
        done error

    it 'should respond with a 200', ->
      expect(@response.statusCode).to.equal 200

    it 'should respond an object containing the meeting', ->
      expect(@body).to.deep.equal {
        calvin:
          id:        'calvin'
          startTime: '16:00:00Z'
          endTime:   '16:30:00Z'
      }
