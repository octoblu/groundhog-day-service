AgendaController = require './controllers/agenda-controller'

class Router
  constructor: () ->

  route: (app) =>
    agendaController = new AgendaController
    app.post '/agendas', agendaController.create

module.exports = Router
