GroundhogDayController = require './controllers/groundhog-day-controller'

class Router
  constructor: ({@groundhogDayService}) ->
    throw new Error 'Missing groundhogDayService' unless @groundhogDayService?

  route: (app) =>
    groundhogDayController = new GroundhogDayController {@groundhogDayService}

    app.get '/hello', groundhogDayController.hello
    # e.g. app.put '/resource/:id', someController.update

module.exports = Router
