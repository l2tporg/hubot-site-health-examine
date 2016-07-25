# Hubot Site Health Examine
====

# Overview

## Description
- hubotに載せてあげてください
- 登録したurlの生死状態を監視し、想定したステータスコードと返却値が異なる時にエラーメッセージを発言します
- ボットを招待したチャネルに対してのみ、ボットは監視情報を発言します

## VS.
hubot-health-check

## Requirement
CoffeeScript

## Install
npm install --save hubot-site-health-examine

## Commands
[省略可能], <引数>
- [BOT_NAME] add \<URL:string\> \<STATUS_CODE:int\> : 検査するサイトを登録
- [BOT_NAME] list : 登録されたサイトをインデックス付きで表示
- [BOT_NAME] update \<INDEX:int\> \<NEW_STATUS_CODE:int\> : 登録されたサイトのインデックスと新しいステータスを指定して更新
- [BOT_NAME] remove \<INDEX:int\> : 登録されたサイトをインデックスを指定して削除

## Licence

[MIT](https://github.com/sak39)

## Author

[sak39](https://github.com/sak39)
