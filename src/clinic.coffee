# Description
#  登録したurlの生死状態を監視し、想定したステータスコードと返却値が異なる時にエラーメッセージを発言します
#  ボットを招待したチャネルに対してのみ、ボットは監視情報を発言します
#
# Commands:
#  [省略可能], <引数>
#  [BOT_NAME] add <URL:string> <STATUS_CODE:int> - 検査するサイトを登録
#  [BOT_NAME] list - 登録されたサイトをインデックス付きで表示
#  [BOT_NAME] update <INDEX:int> <NEW_STATUS_CODE:int> - 登録されたサイトのインデックスと新しいステータスを指定して更新
#  [BOT_NAME] remove <INDEX:int> - 登録されたサイトをインデックスを指定して削除
#
# Author:
#   @sak39
#
# Thanks:
#   http://qiita.com/hotakasaito/items/03386fe1a68e403f5cb8

#cronJob = require('cron').CronJob
Urls = require('./Urls')

module.exports = (robot) ->
  ######定期実行#######
  ###Set interval ###
#  Interval = "1 * * * * *"
#  robot.hear /she set interval "(.+)"/i, (msg) ->
#    console.log msg.match[1]
#    Interval = msg.match[1]
#    msg.send "Set the job interval \"#{Interval}\""
#    cronjob.start()
#    cronjob.stop()
#
#  robot.hear /she start job/i, (msg) ->
#    msg.send "Start job.."
#    cronjob.start()
#
#  robot.hear /she stop job/i, (msg) ->
#    msg.send "Stop job.."
#    cronjob.stop()

  ### cronインスタンス生成###
#  cronjob = new cronJob(
#    cronTime: Interval     # 実行時間 (m h d w m y?) s m h d w m
#    start   : true              # すぐにcronのjobを実行するか
#    timeZone: "Asia/Tokyo"      # タイムゾーン指定
#    onTick  : ->                  # 時間が来た時に実行する処理
#      urls = new Urls(robot)
#      data = urls.getData()
#      for obj in data
#        #healthCheckイベントの発火
#        robot.emit 'healthCheck', {url: obj.url, status: obj.status}
#  )

  ######コマンド群######
  ### 自発的なサイトチェック ###
  robot.hear /she examine/i, (msg) ->
    console.log "examing..." #@@
    urls = new Urls(robot)
    data = urls.getData()
    for obj, key in data
      resolt = robot.emit 'healthExamine', {"url": obj.url, "status": obj.status}
      if resolt.status is "ng" #エラー時のみ発言
        msg.send resolt.discription

  ### Add Urls to check ###
  robot.hear /she[\s]+add[\s]+(\S+)[\s]+(\d+)$/, (msg) ->
    urls = new Urls(robot)
    data = urls.getData()
    url = msg.match[1]
    status = Number(msg.match[2]) #Number型に明示的cast
    i = { url: url, status: status}
    if urls.checkConfliction(data, i.url) #重複検査, data内にi.urlが存在していなければtrue
      data.push i
      robot.brain.set(key, data)
      index = urls.searchIndex(data, "#{i.url}")
      msg.send "added #{index}: #{i.url}, #{i.status}"
    else
      msg.send "Such url had already been registered."

  ### Get List of Urls ###
  robot.hear /she[\s]+list$/, (msg) ->
    urls = new Urls(robot)
    data = urls.getData()
    message = data.map (i) ->
        "#{urls.searchIndex(data, i.url)}: #{i.url} #{i.status}"
      .join '\n'
    if message
      msg.send message
    else
      msg.send "empty"

  ### Update expected status code ###
  robot.hear /she[\s]+update[\s]+(\d+)[\s]+(\d+)$/, (msg) ->
    urls = new Urls(robot)
    data = urls.getData()
    url = msg.match[1]
    status = Number(msg.match[2]) #Number型に明示的cast
    if urls.updateSite url, status
      msg.send "updated #{data[msg.match[1]].url}, #{data[msg.match[1]].status}"
    else
      msg.send "error: There are no such registered site."

  ### Remove Url from list ###
  robot.hear /she[\s]+remove[\s]+(\d+)$/, (msg) ->
    urls = new Urls(robot)
    data = urls.removeSite msg.match[1]
    if data isnt false
      msg.send "removed #{data.url}, #{data.status}"
    else
      msg.send "error: There are no such registered site."
