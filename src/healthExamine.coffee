# Description
#   ステータスチェックを行うイベント
#
# Commands:
#  * ():省略可能, <>:引数, []:どちらか一方
#  (l2-t2) she ex|examine - サイト生死検査イベントを発火します。
#  (l2-t2) she chflag \d\d\d - サイト生死検査イベントの通知設定を変更します。 1st: ERROR時, 2nd: Match時, 3rd: Mismatch時 ... デフォルト値)101: エラー発生もしくはステータスコード異常の時に通知します.
#  (l2-t2) she cron start - ボットのいるチャンネル内でcronを実行します
#  (l2-t2) she cron stop - ボットのいるチャンネル内のcronを停止します
#  (l2-t2) she status - ボットの状態(検査flagの状態、cronの稼働状態)を教えてくれます
#
# Author:
#   @sak39
#
# Thanks:
#   https://github.com/l2tporg/hubot-site-health-examine.git


request = require('request')
cronJob = require('cron').CronJob
Nurse = require('hubot-site-health-manager').NurseWithRedis

# cronjob objの格納(後からstop()するときとかに参照する用)
console.log(cronJobs) #@@
cronJobs = {}

module.exports = (robot) ->
  flags = [1, 0, 1]

  ### flags manager ###
  robot.hear /she chflag (\d\d\d)$/i, (msg) ->
    console.log "flag setting" #@@
    console.log "flag: #{flags}"
    _flags = []
    msg.match[1].split("").map((el, i) ->
      _flags.push(Number(el))
    )
    console.log("_flag; " + _flags)
    flags = _flags
    console.log("flag: " + flags)
    msg.send("chflag SUCCESS: #{flags}")

  ### show status ###
  robot.hear /she status$/i, (msg) ->
    key = msg.envelope.room

    msg.send("flags: #{flags}")
    if cronJobs[key]? and cronJobs[key].running is true
      msg.send("cron: started")
    else
      msg.send("cron: stopped")

  ### 検査メソッドを自発的に発火 ###
  robot.hear /she ex(?:amine)?$/i, (msg) ->
    console.log "examing..." #@@
    console.log(flags)
    key = msg.envelope.room # key == room name
    Nurse.getListAll key, (err, dataArray) ->
      console.log(dataArray);
      for url, status of dataArray
        console.log("url: " + url)
        robot.emit 'healthExamine', url, Number(status), flags, key


  ### cron start & store cronjob obj ###
  robot.hear /she cron start$/i, (msg) ->
    console.log("cron start...")
    msg.send "このチャンネルでcronを開始しました。"
    key = msg.envelope.room
    cronjob = new cronJob(
      cronTime: "1 * * * * *"     # 実行時間 s m h d w m
      start: true              # すぐにcronのjobを実行するか
      timeZone: "Asia/Tokyo"      # タイムゾーン指定
      onTick: ->                  # 時間が来た時に実行する処理
        console.log("cron...")
        Nurse.getListAll key, (err, dataArray) ->
          for url, status of dataArray
            robot.emit 'healthExamine', url, Number(status), flags, key
    )
#    Nurse.addUrl("cronjob", [key, cronjob], msg, (err, res) ->
#      if (res is 'OK')
#        msg.send("Adding SUCCES: '" + key + "' " + cronjob)
#      else if (err)
#        msg.send("Adding ERROR: " + "Unexpected Error \n" + err)
#    )
    cronJobs[key] = cronjob; # cronjob.stop()のためにobjectを保存しておく

  ### cron stop ###
  robot.hear /she cron stop$/i, (msg) ->
    console.log("cron stop...")
    msg.send "このチャンネルのcronを停止しました。"
    key = msg.envelope.room
    cronJobs[key].stop();

  ### cron auto start when bot connected to slack ###
#  do () ->
#    Nurse.getListAll("cronjob", (err, list) ->
#      cronJobs = list;
#      console.log(list);
#      ### k: envelope name, v: cronjob ###
#      for k, v of list
#        v.start();
#    )

  ### Satus Check Event ###
  robot.on 'healthExamine', (_url, _status, flags, _room) ->
    console.log(_room) #@@
    options = {
      url: _url
    }
    request.get options, (err, res) ->
      if err
        robot.send {room: _room}, "ERROR: \"#{_url}\" Connection fail." if flags[0] is 1
      else if res.statusCode is _status
        robot.send {room: _room}, "SUCCESS: \"#{_url}\" has been alive :)" if flags[1] is 1
      else if res.statusCode isnt _status #想定値と異なる時のみ通知
        robot.send {room: _room}, "ERROR: \"#{_url}\" [expect]: #{_status}, [actual]: #{res.statusCode}" if flags[2] is 1



