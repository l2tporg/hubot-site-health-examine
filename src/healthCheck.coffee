# Description
#   ステータスチェックを行うメインクラス(メソッド)
#
# brainやcronからemitで'healthCheck'イベントが呼び出される
#
# Author:
#   @sak39
#

request = require('request')

module.exports = (robot) ->
  ### Only sending error message ver.2###
  robot.on 'healthCheck', (data) ->
    options = {
      url: data.url
    }
#    console.log "data: #{data.url}, #{data.status}" #@@
    request.get options, (err, res, body) ->
#      console.log "res: #{data.url}, #{res.statusCode}" #@@
      if res is undefined
        robot.send err
        robot.send {room: "bot"}, "Error: #{data.url} Connection fail."
      else
#        msg = "#{data.url} is #{res.statusCode}" #ここでerrでもresは取得できる
#        robot.logger.info msg
        if err
          robot.send {room: "bot"}, "Error: Connection fail."
  #        robot.logger.error err
  #        robot.send {room: "notifications"}, err
        else if res.statusCode isnt data.status #想定値と異なる時のみ通知(l2-t2の仕様は、200に限らない)
#          robot.logger.error res.headers
          robot.send {room: "bot"}, "ERROR: #{data.url} [expect]: #{data.status}, [actual]: #{res.statusCode}"
