# Description
#   ステータスチェックを行うイベント
#
# Author:
#   @sak39
#

request = require('request')

module.exports = (robot) ->
  ### Satus Check class ###
  robot.on 'healthExamine', (data, flag, msg) ->
    ###通知オプションの設定###
    flags = flag.split("")
    options = {
      url: data.url
    }
#    console.log "data: #{data.url}, #{data.status}" #@@
    request.get options, (err, res, body) ->
      if err
#        console.log("enter errror") #@@
        if flags[0] is '1'
#          console.log("enter") #@@
          msg.send "Error: #{data.url} Connection fail."
      else
        ###想定値と一致するときは無言###
        if res.statusCode is data.status #想定値と異なる時のみ通知(l2-t2の仕様は、200に限らない)
          msg.send "SUCCESS: #{data.url} has been alive :)" if flags[1] is '1'
        if res.statusCode isnt data.status #想定値と異なる時のみ通知(l2-t2の仕様は、200に限らない)
          msg.send "ERROR: #{data.url} [expect]: #{data.status}, [actual]: #{res.statusCode}" if flags[2] is '1'
    ### set, getメソッドの追加が必要###