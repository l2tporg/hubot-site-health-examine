# Description
#  登録したurlの生死状態を監視し、想定したステータスコードと返却値が異なる時にエラーメッセージを発言します
#  ボットを招待したチャネルに対してのみ、ボットは監視情報を発言します
#
# Commands:
#  [省略可能], <引数>
#  [BOT_NAME] she add <URL:string> <STATUS_CODE:int> - 検査するサイトを登録
#  [BOT_NAME] she list - 登録されたサイトをインデックス付きで表示
#  [BOT_NAME] she update <INDEX:int> <NEW_STATUS_CODE:int> - 登録されたサイトのインデックスと新しいステータスを指定して更新
#  [BOT_NAME] she remove <INDEX:int> - 登録されたサイトをインデックスを指定して削除
#
# Author:
#   @sak39
#
# Thanks:
#   http://qiita.com/hotakasaito/items/03386fe1a68e403f5cb8

Nurse = require('./Nurse')
request = require('request')

module.exports = (robot) ->
  ######コマンド群######
  ### 自発的なサイトチェック ###
  robot.hear /she examine/i, (msg) ->
    console.log "examing..." #@@
    #出力内容の選定
    flag = [1,1,1] #1st: error, 2nd: success, 3rd: fault
    nurse = new Nurse(robot)
    data = nurse.getData()
    for obj, key in data
      robot.emit 'healthExamine', {"url": obj.url, "status": obj.status}, flag, msg

  ### Add nurse to check ###
  robot.hear /she[\s]+add[\s]+(\S+)[\s]+(\d+)$/i, (msg) ->
    nurse = new Nurse(robot)
    data = nurse.getData()
    url = msg.match[1]
    status = Number(msg.match[2]) #Number型に明示的cast
    i = { url: url, status: status}
    if nurse.checkConfliction(data, i.url) #重複検査, data内にi.urlが存在していなければtrue
      data.push i
      robot.brain.set(key, data)
      index = nurse.searchIndex(data, "#{i.url}")
      msg.send "added #{index}: #{i.url}, #{i.status}"
    else
      msg.send "Such url had already been registered."

  ### Get List of nurse ###
  robot.hear /she[\s]+list$/i, (msg) ->
    nurse = new Nurse(robot)
    data = nurse.getData()
    message = data.map (i) ->
        "#{nurse.searchIndex(data, i.url)}: #{i.url} #{i.status}"
      .join '\n'
    if message
      msg.send message
    else
      msg.send "empty"

  ### Update expected status code ###
  robot.hear /she[\s]+update[\s]+(\d+)[\s]+(\d+)$/i, (msg) ->
    nurse = new Nurse(robot)
    data = nurse.getData()
    url = msg.match[1]
    status = Number(msg.match[2]) #Number型に明示的cast
    if nurse.updateSite url, status
      msg.send "updated #{data[msg.match[1]].url}, #{data[msg.match[1]].status}"
    else
      msg.send "error: There are no such registered site."

  ### Remove Url from list ###
  robot.hear /she[\s]+remove[\s]+(\d+)$/i, (msg) ->
    nurse = new Nurse(robot)
    data = nurse.removeSite msg.match[1]
    if data isnt false
      msg.send "removed #{data.url}, #{data.status}"
    else
      msg.send "error: There are no such registered site."
