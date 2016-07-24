# Description
#  ステータスチェックを行うイベント
#  healthからemitで'healthCheck'イベントが呼び出される
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
        robot.send {room: "bot"}, "ERROR: \"#{data.url}\" Connection fail."
      else
        ###想定値と一致するときは無言###
        if res.statusCode isnt data.status #想定値と異なる時のみ通知(l2-t2の仕様は、200に限らない)
          robot.send {room: "bot"}, "ERROR: #{data.url} [expect]: #{data.status}, [actual]: #{res.statusCode}"
