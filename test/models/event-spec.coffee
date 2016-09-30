{afterEach, beforeEach, describe, it} = global
{expect} = require 'chai'
moment = require 'moment'
sinon = require 'sinon'

Event                            = require '../../src/models/event'
NON_RECURRING_TODAY              = require '../fixtures/non-recurring-today.cson'
NON_RECURRING_TODAY_WE_ARE_IN_IT = require '../fixtures/non-recurring-today-we-are-in-it.cson'
NON_RECURRING_YESTERDAY          = require '../fixtures/non-recurring-yesterday.cson'
NON_RECURRING_YONDER             = require '../fixtures/non-recurring-yonder.cson'
RECURRING_TODAY                  = require '../fixtures/recurring-today.cson'
RECURRING_YESTERDAY              = require '../fixtures/recurring-yesterday.cson'
RECURRING_YONDER                 = require '../fixtures/recurring-yonder.cson'
RECURRING_EVERY_WEDNESDAY        = require '../fixtures/recurring-every-wednesday.cson'
RECURRING_EVERY_FRIDAY           = require '../fixtures/recurring-every-friday.cson'
RECURRING_EVERY_SUNDAY           = require '../fixtures/recurring-every-sunday.cson'
RECURRING_EVERY_MONDAY_AND_WEDNESDAY = require '../fixtures/recurring-every-monday-and-wednesday.cson'
RECURRING_EVERY_13TH          = require '../fixtures/recurring-every-13th.cson'
RECURRING_EVERY_3RD_WEDNESDAY = require '../fixtures/recurring-every-3rd-wednesday'
RECURRING_EVERY_3RD_FRIDAY    = require '../fixtures/recurring-every-3rd-friday'
RECURRING_EVERY_31ST_DAY      = require '../fixtures/recurring-every-31st-day'

describe.only 'Event', ->
  beforeEach 'Go back in time to 8am MST 2016-09-28 ', =>
    sinon.useFakeTimers moment('2016-09-28T15:00:00Z').valueOf()

  afterEach 'Back to the future', =>
    sinon.restore()

  describe '-> format', ->
    describe 'non-recurring today', ->
      it 'should return the formatted meeting', ->
        @sut = new Event NON_RECURRING_TODAY.calvin
        expect(@sut.format()).to.deep.equal {
          id:        'calvin'
          startTime: '2016-09-28T16:00:00Z'
          endTime:   '2016-09-28T16:30:00Z'
        }

    describe 'recurring-today', ->
      it 'should return the formatted meeting', ->
        @sut = new Event RECURRING_TODAY.calvin
        expect(@sut.format()).to.deep.equal {
          id:        'calvin'
          startTime: '2016-09-28T16:00:00Z'
          endTime:   '2016-09-28T17:00:00Z'
        }

  describe '-> isInNext24Hours', ->
    describe 'non-recurring-today', ->
      it 'should return true', ->
        @sut = new Event NON_RECURRING_TODAY.calvin
        expect(@sut.isInNext24Hours()).to.be.true

    describe 'non-recurring-yesterday', ->
      it 'should return false', ->
        @sut = new Event NON_RECURRING_YESTERDAY.calvin
        expect(@sut.isInNext24Hours()).to.be.false

    describe 'non-recurring-yonder', ->
      it 'should return false', ->
        @sut = new Event NON_RECURRING_YONDER.calvin
        expect(@sut.isInNext24Hours()).to.be.false

    describe 'non-recurring-today-we-are-in-it', ->
      it 'should return true', ->
        @sut = new Event NON_RECURRING_TODAY_WE_ARE_IN_IT.calvin
        expect(@sut.isInNext24Hours()).to.be.true

    describe 'recurring-today', ->
      it 'should return true', ->
        @sut = new Event RECURRING_TODAY.calvin
        expect(@sut.isInNext24Hours()).to.be.true

    describe 'recurring-yonder', ->
      it 'should return false', ->
        @sut = new Event RECURRING_YONDER.calvin
        expect(@sut.isInNext24Hours()).to.be.false

    describe 'recurring-yesterday', ->
      it 'should return false', ->
        @sut = new Event RECURRING_YESTERDAY.calvin
        expect(@sut.isInNext24Hours()).to.be.false

    describe 'recurring-every-wednesday', ->
      it 'should return true', ->
        @sut = new Event RECURRING_EVERY_WEDNESDAY.calvin
        expect(@sut.isInNext24Hours()).to.be.true

    describe 'recurring-every-friday', ->
      it 'should return false', ->
        @sut = new Event RECURRING_EVERY_FRIDAY.calvin
        expect(@sut.isInNext24Hours()).to.be.false

    describe 'recurring-every-sunday', ->
      beforeEach 'Go back in time to 8am MST 2016-09-25 ', =>
        sinon.useFakeTimers moment('2016-09-25T15:00:00Z').valueOf()

      afterEach 'Back to the future', =>
        sinon.restore()

      it 'should return true', ->
        @sut = new Event RECURRING_EVERY_SUNDAY.calvin
        expect(@sut.isInNext24Hours()).to.be.true

    describe 'recurring-every-monday-and-wednesday', ->
      it 'should return true', ->
        @sut = new Event RECURRING_EVERY_MONDAY_AND_WEDNESDAY.calvin
        expect(@sut.isInNext24Hours()).to.be.true

    describe 'recurring-every-13th', ->
      it 'should return true', ->
        @sut = new Event RECURRING_EVERY_13TH.calvin
        expect(@sut.isInNext24Hours()).to.be.false

    describe 'recurring-every-3rd-wednesday', ->
      it 'should return true', ->
        @sut = new Event RECURRING_EVERY_3RD_WEDNESDAY.calvin
        expect(@sut.isInNext24Hours()).to.be.true

    describe 'recurring-every-3rd-friday', ->
      it 'should return false', ->
        @sut = new Event RECURRING_EVERY_3RD_FRIDAY.calvin
        expect(@sut.isInNext24Hours()).to.be.false

    xdescribe 'recurring-every-31st-day-of-month', ->
      beforeEach 'Go back in time to 8am MST 2016-09-28 ', =>
        sinon.useFakeTimers moment('2016-09-30T15:00:00Z').valueOf()

      afterEach 'Back to the future', =>
        sinon.restore()

      it 'should return true', ->
        @sut = new Event RECURRING_EVERY_31ST_DAY.calvin
        expect(@sut.isInNext24Hours()).to.be.true
