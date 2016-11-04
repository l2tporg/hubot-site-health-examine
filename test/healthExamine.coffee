Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/healthExamine.coffee')

describe 'siteCheck', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'responds to she ex', ->
    @room.user.say('alice', '@hubot she ex').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot she ex']
        ['hubot', '']
      ]

  it 'responds when she cron start', ->
    @room.user.say('alice', '@hubot she cron start').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot she cron start']
        ['hubot', '']
      ]

  it 'responds when she chflag', ->
    @room.user.say('alice', '@hubot she chflag 101').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot she chflag 101']
        ['hubot', '']
      ]

  it 'responds to she ex', ->
    @room.user.say('alice', '@hubot she ex').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot she ex']
        ['hubot', '']
      ]

#  it 'hears orly', ->
#    @room.user.say('bob', 'just wanted to say orly').then =>
#      expect(@room.messages).to.eql [
#        ['bob', 'just wanted to say orly']
#        ['hubot', 'yarly']
#      ]
