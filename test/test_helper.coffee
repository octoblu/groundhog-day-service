require 'fs-cson/register'

chai       = require 'chai'
sinonChai  = require 'sinon-chai'
chaiSubset = require 'chai-subset'

chai.use sinonChai
chai.use chaiSubset
