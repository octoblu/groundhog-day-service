moment = require 'moment'

class Event
  constructor: ({@id, @startDate, @startTime, @duration}) ->

  format: () =>
    return {
      id: @id
      startTime: @_startMoment().format()
      endTime: @_endMoment().format()
    }

  isInNext24Hours: =>
    now      = moment.utc()
    tomorrow = moment.utc().add 1, 'day'

    return true if @_isWithin {time: @_startMoment(), startTime: now, endTime: tomorrow}
    return true if @_isWithin {time: @_endMoment(),   startTime: now, endTime: tomorrow}
    return false

  _endMoment: =>
    startMoment = @_startMoment({@startDate, @startTime})
    startMoment.add @duration.length, @duration.units

  _isWithin: ({time, startTime, endTime}) =>
    return startTime.isBefore(time) && endTime.isAfter(time)

  _startMoment: =>
    moment.utc("#{@startDate}T#{@startTime}", "YYYY-MM-DDTHH:mm")

module.exports = Event
