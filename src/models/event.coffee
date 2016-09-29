moment = require 'moment'

class Event
  constructor: ({@id, @startDate, @startTime, @duration}) ->

  isInNext24Hours: =>
    now      = moment.utc()
    tomorrow = moment.utc().add 1, 'day'

    startMoment = @_calculateStartMoment({@startDate, @startTime})
    endMoment   = @_calculateEndMoment({@startDate, @startTime, @duration})

    return true if @_isWithin {time: startMoment, startTime: now, endTime: tomorrow}
    return true if @_isWithin {time: endMoment, startTime: now, endTime: tomorrow}
    return false

  _calculateEndMoment: ({startDate, startTime, duration}) =>
    startMoment = @_calculateStartMoment({startDate, startTime})
    startMoment.add(duration.length, duration.units)

  _calculateStartMoment: ({startDate, startTime}) =>
    moment.utc("#{startDate}T#{startTime}", "YYYY-MM-DDTHH:mm")

  format: () =>
    startMoment = @_calculateStartMoment({@startDate, @startTime})
    endMoment = @_calculateEndMoment({@startDate, @startTime, @duration})

    return { @id, startTime: startMoment.format(), endTime: endMoment.format() }

  _isWithin: ({time, startTime, endTime}) =>
    return startTime.isBefore(time) && endTime.isAfter(time)

module.exports = Event
