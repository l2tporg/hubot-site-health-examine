# Description
#   ステータスチェックを行うイベント
#
# Author:
#   @sak39
#

request = require('request')

module.exports = (robot) ->
  ### Satus Check Event ###
  robot.on 'healthExamine', (site, flags, _room="bot") ->
    console.log(_room) #@@
    console.dir site #@@
    options = {
      url: site.url
    }
    request.get options, (err, res, body) ->
      if err
        robot.send {room: _room}, "Error: \"#{site.url}\" Connection fail." if flags[0] is 1
      else if res.statusCode is site.status #想定値と異なる時のみ通知
        robot.send {room: _room}, "SUCCESS: \"#{site.url}\" has been alive :)" if flags[1] is 1
      else if res.statusCode isnt site.status #想定値と異なる時のみ通知
        console.log res #@@
        robot.send {room: _room}, "ERROR: \"#{site.url}\" [expect]: #{site.status}, [actual]: #{res.statusCode}" if flags[2] is 1
