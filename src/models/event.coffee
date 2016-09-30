later  = require 'later'
_      = require 'lodash'
moment = require 'moment'

later.date.UTC()

class Event
  constructor: ({@id, @startDate, @endDate, @duration, schedules}) ->
    throw new Error 'Missing required parameter: startDate' unless @startDate?
    throw new Error 'Missing required parameter: schedules' unless  schedules?
    @endDate ?= @startDate

    @ogSchedules = schedules

    @schedules = _.map schedules, (schedule) =>
      obj = {
        h: _.map schedule.startTimes, (time) => moment(time, 'HH:mm:ss').hour()
        m: _.map schedule.startTimes, (time) => moment(time, 'HH:mm:ss').minute()
      }

      unless _.isEmpty schedule.daysOfMonth
        obj.day = schedule.daysOfMonth

      unless _.isEmpty schedule.daysOfWeek
        obj.dayOfWeek = _.map schedule.daysOfWeek, (day) => moment().day(day).day() + 1

      return obj

  format: () =>
    startOfNextEvent = @_startOfNextEvent()
    endOfNextEvent   = @_endOfNextEvent()

    return null unless startOfNextEvent? && endOfNextEvent?

    return {
      id: @id
      startTime: startOfNextEvent.format()
      endTime:   endOfNextEvent.format()
    }

  isInNext24Hours: =>
    startOfNextEvent = @_startOfNextEvent()
    console.log 'startOfNextEvent', startOfNextEvent?.format()
    return startOfNextEvent?

  _endOfLastEvent: =>
    lastStartTime = _.max _.flatten _.map(@ogSchedules, 'startTimes')

    lastStartMoment = moment.utc("#{@endDate}T#{lastStartTime}", "YYYY-MM-DDTHH:mm:ss")
    lastStartMoment.add @duration.length, @duration.units

  _endOfNextEvent: =>
    startOfNextEvent = @_startOfNextEvent()
    return null unless startOfNextEvent?
    moment(startOfNextEvent).add @duration.length, @duration.units

  _isInNext24HoursSingleOccurance: =>
    return true if @_isWithin24Hours @_startOfFirstEvent()
    return true if @_isWithin24Hours @_endOfLastEvent()
    return false

  _isWithin24Hours: (time) =>
    now      = moment.utc()
    tomorrow = moment.utc().add 1, 'day'

    return now.isBefore(time) && tomorrow.isAfter(time)

  _startOfNextEvent: =>
    startOfPeriod = moment.utc().subtract @duration.length, @duration.units
    startOfPeriod = @_startOfFirstEvent() if @_startOfFirstEvent().isAfter startOfPeriod

    endOfPeriod = moment.utc().add 1, 'day'
    endOfPeriod = @_endOfLastEvent() if @_endOfLastEvent().isBefore endOfPeriod

    schedule = later.schedule({@schedules})
    next     = schedule.next(1, startOfPeriod.toDate(), endOfPeriod.toDate())

    return null if next == 0
    return moment.utc next

  _startOfFirstEvent: =>
    moment.utc("#{@startDate}T#{@startTime}", "YYYY-MM-DDTHH:mm")

module.exports = Event
