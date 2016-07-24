# Description
#  ステータスチェックを行うイベント
#
# Author:
#   @sak39

request = require('request')

module.exports = (robot) ->
  robot.on 'healthCheck', (data) ->
    options = {
      url: data.url
    }
    request.get options, (err, res, body) ->
      if err?
        robot.send "ERROR: \"#{data.url}\" Connection fail."
      else
        ###想定値と一致するときは無言###
        if res.statusCode isnt data.status #想定値と異なる時のみ通知
          robot.send "ERROR: #{data.url} [expect]: #{data.status}, [actual]: #{res.statusCode}"
