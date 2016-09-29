_      = require 'lodash'
moment = require 'moment'

class AgendaController
  constructor: () ->

  create: (request, response) =>
    now      = moment.utc()
    tomorrow = moment.utc().add 1, 'day'

    result = _.mapValues request.body, ({id, startDate, startTime, duration}) =>
      startMoment = moment.utc("#{startDate}T#{startTime}", "YYYY-MM-DDTHH:mm")
      endMoment   = moment(startMoment).add(duration.length, duration.units)

      return @_format {id, startMoment, endMoment} if @_isWithin {time: startMoment, startTime: now, endTime: tomorrow}
      return @_format {id, startMoment, endMoment} if @_isWithin {time: endMoment, startTime: now, endTime: tomorrow}
      return null

    response.send _.omitBy result, _.isNil

  _format: ({id, startMoment, endMoment}) =>
    return { id, startTime: startMoment.format(), endTime: endMoment.format() }

  _isWithin: ({time, startTime, endTime}) =>
    return startTime.isBefore(time) && endTime.isAfter(time)

module.exports = AgendaController
