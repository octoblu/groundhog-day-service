class GroundhogDayController
  constructor: ({@groundhogDayService}) ->
    throw new Error 'Missing groundhogDayService' unless @groundhogDayService?

  hello: (request, response) =>
    {hasError} = request.query
    @groundhogDayService.doHello {hasError}, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(200)

module.exports = GroundhogDayController
