chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'health-check', ->
  beforeEach ->
    @robot =
      router:
        get: sinon.spy()

    require('../src/health')(@robot)

  it 'registers a GET route', ->
    expect(@robot.router.get).to.have.been.calledWith('/')
