# encoding: utf-8
# language: ja

# step定義の追加サンプルです。

require 'pp'

step 'アセット読み込み' do
  # visit '/css/xxx.css'
  # visit '/css/xxx.css'
  # visit '/css/xxx.css'
  # visit '/css/xxx.css'
end

step 'DBを初期化する' do
  system('mysql xxx -pxxx -hxxx < /spec/sqls/init.sql')
end
