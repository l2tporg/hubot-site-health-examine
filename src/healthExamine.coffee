# Description
#   ステータスチェックを行うイベント
#
# Author:
#   @sak39
#

request = require('request')

module.exports = (robot) ->
  ### Satus Check class ###
  robot.on 'healthExamine', (sites, flags, msg) ->
    for obj, key in sites
      site = {"url": obj.url, "status": obj.status}

      options = {
        url: site.url
      }
      request.get options, (err, res, body) ->
        if err
          msg.send "Error: \"#{site.url}\" Connection fail." if flags[0] is 1
        else if res.statusCode is site.status #想定値と一致する時のみ通知
          msg.send "SUCCESS: \"#{site.url}\" has been alive :)" if flags[1] is 1
        else if res.statusCode isnt site.status #想定値と異なる時のみ通知
          msg.send "ERROR: \"#{site.url}\" [expect]: #{site.status}, [actual]: #{res.statusCode}" if flags[2] is 1
