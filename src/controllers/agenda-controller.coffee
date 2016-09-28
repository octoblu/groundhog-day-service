_      = require 'lodash'
moment = require 'moment'

class AgendaController
  constructor: () ->

  create: (request, response) =>
    now      = moment.utc()
    tomorrow = moment.utc().add 1, 'day'

    result = _.pickBy request.body, ({startTime, endTime}) =>
      return true if @_isWithin({time: startTime, startTime: now, endTime: tomorrow})
      return true if @_isWithin({time: endTime, startTime: now, endTime: tomorrow})
      return false

    response.send result

  _isWithin: ({time, startTime, endTime}) =>
    return startTime.isBefore(time) && endTime.isAfter(time)

module.exports = AgendaController
