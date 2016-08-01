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
    message = {}
    request.get options, (err, res, body) ->
      ### 以下二つが実行される前にreturnがされる###
#      console.log(err) #@@
#      console.log(res.statusCode) #@@
      if err
        message = {"status": "error", "statusCode": null, "discription": "ERROR: \"#{data.url}\" Connection fail."}
#        return message
      else if res.statusCode is data.status #想定値と一致する時
        message = {"status": "matched", "statusCode": "#{res.statusCode}", "discription": "SUCCESS: \"#{data.url}\" has been alive :)"}
#        return message
      else if res.statusCode isnt data.status #想定値と異なる時
        message = {"status": "unmatched", "statusCode": "#{res.statusCode}", "discription": "ERROR: \"#{data.url}\" [expect]: \"#{data.status}\", [actual]: \"#{res.statusCode}\""}
#        return message
    return message

module.exports = Doctor
