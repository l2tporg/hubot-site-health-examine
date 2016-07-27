# Description
#   ステータスチェックを行うメソッドを持つクラス
#
# Author:
#   @sak39
#
# Thanks:
#   http://sota1235.hatenablog.com/entry/2015/06/15/001400


request = require('request')

class Doctor
  constructor: () ->
  ###### Modules #######
  # Site health examine function
  examine: (data) ->
    options = {
      url: data.url
    }
#    msg = {}
    request.get options, (err, res, body) ->
      ### 以下二つが実行される前にreturnがされる###
      console.log(err) #@@
      console.log(res.statusCode) #@@
      if err
        msg = {"status": "error", "statusCode": null, "discription": "ERROR: \"#{data.url}\" Connection fail."}
        return msg
      else if res.statusCode is data.status #想定値と一致する時
        msg = {"status": "matched", "statusCode": "#{res.statusCode}", "discription": "SUCCESS: \"#{data.url}\" has been alive :)"}
        return msg
      else if res.statusCode isnt data.status #想定値と異なる時
        msg = {"status": "unmatched", "statusCode": "#{res.statusCode}", "discription": "ERROR: \"#{data.url}\" [expect]: \"#{data.status}\", [actual]: \"#{res.statusCode}\""}
        return msg

module.exports = Doctor
