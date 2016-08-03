# Description
#   ステータスチェックを行うイベント
#
# Author:
#   @sak39
#

request = require('request')

module.exports = (robot) ->
  ### Satus Check Event ###
  robot.on 'healthExamine', (data, flags, msg) ->
    options = {
      url: data.url
    }
    request.get options, (err, res, body) ->
      if err
        msg.send "Error: #{data.url} Connection fail." if flags[0] is 1
      else if res.statusCode is data.status #想定値と異なる時のみ通知
          msg.send "SUCCESS: #{data.url} has been alive :)" if flags[1] is 1
      else if res.statusCode isnt data.status #想定値と異なる時のみ通知
          msg.send "ERROR: #{data.url} [expect]: #{data.status}, [actual]: #{res.statusCode}" if flags[2] is 1
