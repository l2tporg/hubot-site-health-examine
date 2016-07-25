# Description
#  ステータスチェックを行うイベント
#
# Author:
#   @sak39

request = require('request')

module.exports = (robot) ->
  robot.on 'healthExamine', (data) ->
    options = {
      url: data.url
    }
    request.get options, (err, res, body) ->
      if err?
        return {"status": "error", "statusCode": null, "discription": "ERROR: \"#{data.url}\" Connection fail."}
      else
        ###想定値と一致するときは無言###
        if res.statusCode is data.status #想定値と一致する時
          return {"status": "matched", "statusCode": res.statusCode, "discription": null}
        else if res.statusCode isnt data.status #想定値と異なる時
          return {"status": "unmatched", "statusCode": res.statusCode, "discription": "ERROR: #{data.url} [expect]: #{data.status}, [actual]: #{res.statusCode}"}
#  robot.on 'healthExamine', (data) ->
#    options = {
#      url: data.url
#    }
#    request.get options, (err, res, body) ->
#      if err?
#        robot.send "ERROR: \"#{data.url}\" Connection fail."
#      else
#        ###想定値と一致するときは無言###
#        if res.statusCode isnt data.status #想定値と異なる時のみ通知
#          robot.send "ERROR: #{data.url} [expect]: #{data.status}, [actual]: #{res.statusCode}"
