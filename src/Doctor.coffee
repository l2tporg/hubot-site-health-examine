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
  examine: (sites, callback, msg) ->
    console.log("Doctor: well, I'm examining.") #@@
    for obj, key in sites
      site = {"url": obj.url, "status": obj.status}
      options = {
        url: site.url
      }
      message = {}
      request.get options, (err, res, body) ->
        if err
          message = {"status": "error", "statusCode": null, "discription": "ERROR: \"#{site.url}\" Connection fail."}
          callback(message, msg)
        else if res.statusCode is site.status #想定値と一致する時
          message = {"status": "matched", "statusCode": "#{res.statusCode}", "discription": "SUCCESS: \"#{site.url}\" has been alive :)"}
          callback(message, msg)
        else if res.statusCode isnt site.status #想定値と異なる時
          message = {"status": "unmatched", "statusCode": "#{res.statusCode}", "discription": "ERROR: \"#{site.url}\" [expect]: \"#{site.status}\", [actual]: \"#{res.statusCode}\""}
          callback(message, msg)

module.exports = Doctor
