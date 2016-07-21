# Description
#   1つランダムに選ぶ
#
# Commands:
#   hubot choice ほげ もげ ふが -- 引数からランダムにchoice
#   hubot choice $<groupname> -- 登録されたグループの要素の中からランダムにchoice
#   hubot choice set <group name> <group elements> -- グループを設定
#   hubot choice delete <group name> -- グループを削除
#   hubot dump -- 登録されているグループ一覧を表示
#
# Author:
#   @sota1235
#
# Thanks:
#   https://github.com/masuilab/slack-hubot/blob/master/scripts/choice.coffee

_ = require 'lodash'

module.exports = (robot) ->
  CHOICE = 'choice_data'

  # データ取得
  getData = () ->
    data = robot.brain.get(CHOICE) or {}
    return data

  # データセット
  setData = (data) ->
    robot.brain.set CHOICE, data

  # グループをセット
  setGroup = (groupName, groupElement) ->
    data = getData()
    data[groupName] = groupElement
    setData(data)
    return

  # グループを削除
  deleteGroup = (groupName) ->
    data = getData()
    if data[groupName] is undefined
      return false
    delete data[groupName]
    return true

  # グループ要素を取得
  getGroupElem = (groupName) ->
    data = getData()
    if data[groupName] is undefined
      return false
    else
      return data[groupName]

  robot.respond /choice (.+)/i, (msg) ->
    items = msg.match[1].split(/\s+/)
    head  = items[0] # for judge command is choice or not

    # set, dump,deleteの場合、return
    if head is 'set' or head is 'dump' or head is 'delete'
      return

    # 第一引数がグループ名指定の場合
    if /\$(.+)/.test items[0]
      items = getGroupElem items[0].substring(1)
      if not items
        msg.send "無効なグループ名です"
        return

    choice = _.sample items
    msg.send "厳正な抽選の結果、「#{choice}」に決まりました"

  # グループを設定
  robot.respond /choice set (.+)/i, (msg) ->
    items = msg.match[1].split(/\s+/)
    groupName    = items[0]
    items.shift()
    groupElement = items
    setGroup groupName, groupElement
    msg.send "グループ：#{groupName}を設定しました"

  # グループを削除
  robot.respond /choice delete (.+)/i, (msg) ->
    groupName = msg.match[1].split(/\s+/)[0]
    if deleteGroup groupName
      msg.send "グループ：#{groupName}を削除しました。"
    else
      msg.send "グループ：#{groupName}は存在しません。"

  # for debug
  robot.respond /choice dump/i, (msg) ->
    data = getData()
    if _.size(data) is 0
      msg.send "現在登録されているグループはありません"
      return
    for gname, gelm of data
      msg.send "#{gname}: #{gelm.join()}"