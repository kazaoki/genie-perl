# encoding: utf-8
# language: ja

# step定義の追加サンプルです。

require 'pp'

asset_loaded = 0
step 'アセット読み込み' do
  return if asset_loaded != 0 # アセットのロードは一度のみの実行。
  asset_loaded += 1
  visit '/css/xxx.css'
end

step 'DBを初期化する' do
  system('mysql xxx -pxxx -hxxx < /spec/sqls/init.sql')
end
