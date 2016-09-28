_      = require 'lodash'
moment = require 'moment'

class AgendaController
  constructor: () ->

  create: (request, response) =>
    now      = moment.utc()
    tomorrow = moment.utc().add 1, 'day'

    result = _.pickBy request.body, ({startTime}) =>
      return @_isWithin({time: startTime, startTime: now, endTime: tomorrow})

      return now.isBefore(startTime) && tomorrow.isAfter(startTime)

    response.send result

  _isWithin: ({time, startTime, endTime}) =>
    return startTime.isBefore(time) && endTime.isAfter(time)

module.exports = AgendaController
