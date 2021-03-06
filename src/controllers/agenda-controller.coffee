_      = require 'lodash'

Event = require '../models/event'

class AgendaController
  constructor: () ->

  create: (request, response) =>
    events = _.mapValues request.body, ({id, startDate, startTime, duration, endDate, repeats}) =>
      new Event {id, startDate, startTime, duration, endDate, repeats}

    upcomingEvents = _.pickBy events, (event) => event.isInNext24Hours()

    response.send _.mapValues upcomingEvents, (event) => event.format()

module.exports = AgendaController
