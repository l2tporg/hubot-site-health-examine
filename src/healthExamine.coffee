# Description
#   ステータスチェックを行うイベント
#
# Author:
#   @sak39
#

request = require('request')

module.exports = (robot) ->
  ### Satus Check Event ###
  robot.on 'healthExamine', (sites, flags) ->
    for obj, key in sites
      options = {
        url: obj.url
      }
      request.get options, (err, res, body) ->
        if err
          robot.send "Error: \"#{obj.url}\" Connection fail." if flags[0] is 1
        else if res.statusCode is obj.status #想定値と異なる時のみ通知
          robot.send "SUCCESS: \"#{obj.url}\" has been alive :)" if flags[1] is 1
        else if res.statusCode isnt obj.status #想定値と異なる時のみ通知
          robot.send "ERROR: \"#{obj.url}\" [expect]: #{obj.status}, [actual]: #{res.statusCode}" if flags[2] is 1
