# Description
#   ステータスチェックを行うイベント
#
# Commands:
#  - []:省略可能, <>:引数
#  [l2-t2] she add <URL:string> <STATUS:int> - 検査するサイトを登録
#  [l2-t2] she list - 登録されたサイトをインデックス付きで表示
#  [l2-t2] she update <INDEX:int> <NEW_STATUS:int> - 登録されたサイトのインデックスと新しいステータスを指定して更新
#  [l2-t2] she remove <INDEX:int> - 登録されたサイトをインデックスを指定して削除
#  *[l2-t2] she examine - 監視メソッドを自発的に発火
#
# Author:
#   @sak39
#
# Thanks:
#   https://github.com/l2tporg/hubot-site-health-examine.git


request = require('request')

module.exports = (robot) ->
  ### Satus Check Event ###
  robot.on 'healthExamine', (site, flags, _room="bot") ->
    console.log(_room) #@@
    console.dir site #@@
    options = {
      url: site.url
    }
    request.get options, (err, res, body) ->
      if err
        robot.send {room: _room}, "Error: \"#{site.url}\" Connection fail." if flags[0] is 1
      else if res.statusCode is site.status #想定値と異なる時のみ通知
        robot.send {room: _room}, "SUCCESS: \"#{site.url}\" has been alive :)" if flags[1] is 1
      else if res.statusCode isnt site.status #想定値と異なる時のみ通知
        console.log res #@@
        robot.send {room: _room}, "ERROR: \"#{site.url}\" [expect]: #{site.status}, [actual]: #{res.statusCode}" if flags[2] is 1
