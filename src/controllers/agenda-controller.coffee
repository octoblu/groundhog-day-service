_      = require 'lodash'
moment = require 'moment'

class AgendaController
  constructor: () ->

  create: (request, response) =>
    now = moment.utc()

    result = _.pickBy request.body, (item) =>
      startDay = moment.utc(item.startDate, 'YYYY-MM-DD')
      console.log 'startDay', startDay.format()
      console.log 'now', now.format()
      return startDay.isAfter now

    response.send result

module.exports = AgendaController
