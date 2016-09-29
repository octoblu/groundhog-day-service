later  = require 'later'
_      = require 'lodash'
moment = require 'moment'

later.date.UTC()

class Event
  constructor: ({@id, @startDate, @startTime, @duration, @endDate, @repeats}) ->
    throw new Error 'Missing required parameter: startDate' unless @startDate?
    @endDate ?= @startDate

  format: () =>
    startOfNextEvent = @_nextEvent()
    endOfNextEvent = moment(startOfNextEvent).add @duration.length, @duration.units
    return {
      id: @id
      startTime: startOfNextEvent.format()
      endTime: endOfNextEvent.format()
    }

  isInNext24Hours: =>
    return @_isInNext24HoursSingleOccurance() if _.isEmpty @repeats
    return @_isInNext24HoursRecurring()

  _endOfLastEvent: =>
    lastStartTime = moment.utc("#{@endDate}T#{@startTime}", "YYYY-MM-DDTHH:mm")
    lastStartTime.add @duration.length, @duration.units

  _isInNext24HoursRecurring: =>
    now      = moment.utc()
    tomorrow = moment.utc().add 1, 'day'

    return false if @_startOfFirstEvent().isAfter(tomorrow)
    return false if @_endOfLastEvent().isBefore(now)

    next = @_nextEvent()

    return @_isWithin24Hours(next)

  _isInNext24HoursSingleOccurance: =>
    return true if @_isWithin24Hours @_startOfFirstEvent()
    return true if @_isWithin24Hours @_endOfLastEvent()
    return false

  _isWithin24Hours: (time) =>
    now      = moment.utc()
    tomorrow = moment.utc().add 1, 'day'

    return now.isBefore(time) && tomorrow.isAfter(time)

  _nextEvent: =>
    hour   = @_startOfFirstEvent().hour()
    minute = @_startOfFirstEvent().minute()
    schedule = h: [hour], m: [minute]

    unless _.isEmpty @repeats?.daysOfWeek
      schedule.dw = _.map @repeats.daysOfWeek, (day) =>
        moment().day(day).day() + 1

    schedule.D = @repeats?.daysOfMonth unless _.isEmpty @repeats?.daysOfMonth
    laterSchedule = later.schedule(schedules: [schedule])
    nowMinusDuration = moment.utc().subtract @duration.length, @duration.units
    return moment.utc laterSchedule.next(1, nowMinusDuration)

  _startOfFirstEvent: =>
    moment.utc("#{@startDate}T#{@startTime}", "YYYY-MM-DDTHH:mm")

module.exports = Event
