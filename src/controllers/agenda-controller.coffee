class AgendaController
  constructor: () ->

  create: (request, response) =>
    response.send request.body

module.exports = AgendaController
