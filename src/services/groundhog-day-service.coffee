class GroundhogDayService
  doHello: ({hasError}, callback) =>
    return callback @_createError(500, 'Not enough dancing!') if hasError?
    callback()

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = GroundhogDayService
