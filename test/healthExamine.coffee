Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/healthExamine.coffee')

describe 'siteCheck', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  ### sample ###
#  it 'responds to she ex', ->
#    @room.user.say('alice', '@hubot she ex').then =>
#      expect(@room.messages).to.eql [
#        ['alice', '@hubot she ex']
#        ['hubot', '']
#      ]
#
  ### cron ###
  it 'responds when she cron start', ->
    @room.user.say('alice', '@hubot she cron start').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot she cron start']
        ['hubot', 'このチャンネルでcronを開始しました。']
      ]

#  it 'responds when she cron stop', ->
#    @room.user.say('alice', '@hubot she cron stop').then =>
#      expect(@room.messages).to.eql [
#        ['alice', '@hubot she cron stop']
#        ['hubot', '']
#      ]
#
  ### chflag ###
#  it 'responds when she chflag', ->
#    @room.user.say('alice', '@hubot she chflag 101').then =>
#      expect(@room.messages).to.eql [
#        ['alice', '@hubot she chflag 101']
#        ['hubot', '']
#      ]
#
  ### she status ###
  it 'responds to she status', ->
    @room.user.say('alice', '@hubot she status').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot she status']
        ['hubot', 'flags: 1,0,1']
        ['hubot', 'cron: started']
      ]

  ### she ex ###
#  it 'responds to she ex', ->
#    @room.user.say('alice', '@hubot she ex').then =>
#      expect(@room.messages).to.eql [
#        ['alice', '@hubot she ex']
#        ['hubot', '']
#      ]
#
#  it 'hears orly', ->
#    @room.user.say('bob', 'just wanted to say orly').then =>
#      expect(@room.messages).to.eql [
#        ['bob', 'just wanted to say orly']
#        ['hubot', 'yarly']
#      ]
