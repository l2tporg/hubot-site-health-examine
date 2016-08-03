# Hubot Site Health Examine
====

# Overview

## Description
- hubotに載せてあげてください。
- 登録したurlの生死状態を監視し、想定したステータスコードと返却値が異なる時にエラーメッセージを発言します。
- ボットを招待したチャネルに対してのみ、ボットは監視情報を発言します。

## Features
- hubot-site-health-examineで提供する機能は以下のとおり
1. 監視したいサイトのURLリストのCRUD管理 -> CRUD, Commandsの項目を参照
2. 監視したいサイトを走査する監視メソッドを実行(healthExamineイベントと、Doctorクラスのいずれかで実行可能) -> Usage, Examine Methodの項目を参照

## Requirement
CoffeeScript

## Install
1. `npm install --save hubot-site-health-examine`を実行する。(--saveはお好みで)
2. `external-scripts.json`に`"hubot-site-health-examine"`を追記する。

## Usage
### モジュールを読み込む
```coffeescript
#監視したいサイトのリストを管理するクラス
Nurse = require('hubot-site-health-examine').Nurse

#Doctorクラスを使って監視メソッドを実行する場合に追記
Doctor = require('hubot-site-health-examine').Doctor
```

### 監視メソッドを実行するスクリプトを作成する

#### 1. NurseのgetListメソッド
- 登録した監視したいサイトのURLリストを取得する
```coffeescript
# Nurseインスタンスを生成(robotオブジェクトを渡す)
nurse = new Nurse(robot)
# getListメソッドでURLリストを取得
list = nurse.getList()
```

#### 2-1. healthExamineイベントを使った方法
- `robot.emit 'healthExamine', list, flags, msg`
- この方法では、渡したflagsの内容に従って、イベント内部であらかじめ設定された発言を行う。

##### 引数
- list : 監視対象のリスト
- flags : 発言したい内容の選択([1,0,1]のようにして指定) 0:無効, 1:有効
  - 1桁目: エラー時に発言
  - 2桁目: 想定したstatusCodeと実際のstatusCodeが一致した場合に発言
  - 3桁目: 想定したstatusCodeと実際のstatusCodeが不一致の場合に発言
- msg : `robot.hear`でコールバックに渡された引数。発言処理に必要(`msg.send`)。

##### サンプルコード
```coffeescript
robot.hear /she examine e/i, (msg) ->
  nurse = new Nurse(robot)
  ###出力内容の選定###
  ###1st: error, 2nd: success, 3rd: fault###
  flags = [1,1,1] #すべての場合で発言
  list = nurse.getList()
  robot.emit 'healthExamine', list, flags, msg
```

#### 2-2. Doctorクラスを使った方法
- `doctor.examine list, examineCallback, msg`
- この方法では、doctor.examineメソッドが戻り値として検査内容のオブジェクトを返す。

##### 引数
- list : 監視対象のリスト
- examineCallback : 走査終了後に処理したいメソッド。ここで発言処理などを行う。
- msg : `robot.hear`でコールバックに渡された引数。発言処理に必要(`msg.send`)。

##### 戻り値
- examineメソッド実行後に以下の形の戻り値がresultに渡される
```javascript
# コネクションエラーの場合
message = {
  "status": "error",
  "statusCode": null,
  "discription": "ERROR: \"" + site.url + "\" Connection fail."
};

# 想定値と実際値が一致した場合
message = {
  "status": "matched",
  "statusCode": "" + res.statusCode,
  "discription": "SUCCESS: \"" + site.url + "\" has been alive :)"
};

# 想定値と実際値が不一致の場合
message = {
  "status": "unmatched",
  "statusCode": "" + res.statusCode,
  "discription": "ERROR: \"" + site.url + "\" [expect]: \"" + site.status + "\", [actual]: \"" + res.statusCode + "\""
};
```

##### サンプルコード
```coffeescript
robot.hear /she examine d/i, (msg) ->
  doctor = new Doctor()
  nurse = new Nurse(robot)
  data = nurse.getList()
  doctor.examine data, examineCallback, msg

### callback ###
examineCallback = (result, msg) ->
  if result.status is "error"
  msg.send "#{result.discription}"
  else if result.status is "matched"
  msg.send "#{result.discription}"
  else if result.status is "unmatched"
  msg.send "#{result.discription}"
```

### CRUD管理
- 以下の形式で監視したいサイトのURLを登録する
- SITE_URL: http(s)://から記述する。String型。
- STATUS_CODE: Number型(200,404,503..etc)。
```
data = [
  {"url": "SITE_URL", "status": STATUS_CODE},
  {"url": "SITE_URL", "status": STATUS_CODE},
  {"url": "SITE_URL", "status": STATUS_CODE}
];
```

## Commands

#### []:省略可能, <>:引数
- [BOT_NAME] she add \<URL:string\> \<STATUS_CODE:int\> : 検査するサイトを登録
- [BOT_NAME] she list : 登録されたサイトをインデックス付きで表示
- [BOT_NAME] she update \<INDEX:int\> \<NEW_STATUS_CODE:int\> : 登録されたサイトのインデックスと新しいステータスを指定して更新
- [BOT_NAME] she remove \<INDEX:int\> : 登録されたサイトをインデックスを指定して削除

### サンプルコマンド
- [BOT_NAME] she examine with event : eventを使って監視メソッドを実行
- [BOT_NAME] she examine with doctor : Doctorクラスを使って監視メソッドを実行

## Licence

[MIT](https://github.com/sak39)

## Author

[sak39](https://github.com/sak39)
