# genie

### `ドキュメント準備中...`

dockerオーケストレーションツールの一種で、ウェブ制作/開発に特化した開発環境サーバをローカル上に展開できます。ジーニーって読んでください。  
ウェブ確認、テスト実行、データベース、セキュリティチェック等のウェブ開発に必要最低限の機能を実行することができます。
プロジェクトごとに設定ファイルを調整することで、本番のサーバに近い環境を手軽に準備できます。

dockerイメージ `kazaoki/genie` に `Apache`, `Nginx`, `Perl`, `PHP`, `Ruby`, `Postfix`, 等が用意され、`MySQL`, `PostgreSQL`, `OWASP/ZAP` 等のソフトウェアはオフィシャルdockerイメージを利用して外部コンテナとして起動します。（dcokerオーケストレーション）

## 基本的な使い方

	$ genie init

同ディレクトリに .genie/config.pl が作成されますのでDBアカウント情報やドキュメントルートなどを記述します。

	$ genie up

必要なコンテナが起動して自動で該当のページでブラウザが開くので、開発を進めます。  
作業が終わり、コンテナを終了するときは、

	$ genie down

してください。  
翌日、作業の続きをしたければ、プロジェクトディレクトリ上で `genie up` するだけで同じサーバ環境が立ち上がります。  
基本的にこれだけです。


設定ファイルの説明やその他の機能は後述します。


## 必要環境
- perl
	+ 必須モジュール（エラーが出る場合は入れて下さい）
		* XML::Simple （cpanまたはyumで `sudo yum install -y perl-XML-Simple` ）
- docker（Toolbox可）
- git


Windows, Mac, Linux どれでもOK。
Windowsなら [Strawberry Perl for Windows](http://strawberryperl.com/) をおすすめします。


## genieコマンドをインストールする

本体のインストールは一度でOKです。
以下の手順を行うことで、どこからでも `genie` コマンドが打てるようになります。

#### for Windows

Windowsは perl コマンドでファイルを２つダウンロードします。

	perl -MLWP::Simple -e "getprint 'https://raw.githubusercontent.com/kazaoki/genie/master/cmd/genie'" > genie
	perl -MLWP::Simple -e "getprint 'https://raw.githubusercontent.com/kazaoki/genie/master/cmd/genie.bat'" > genie.bat

次に、ダウンロードした `genie` と `genie.bat` をPATH通ってるところへ移動してください。またはダウンロードしたPATHを環境変数PATHに追加して再起動してください。


#### for Mac, Linux

MacOSとLinuxは curl コマンドで１つファイルをダウンロードしてきます。

	sudo curl -o /usr/local/bin/genie https://raw.githubusercontent.com/kazaoki/genie/master/cmd/genie
	sudo chmod +x /usr/local/bin/genie

## genieコマンドをアンインストールする

上記でインストールした `genie` ファイルを探して削除してください。Windowsの場合は、 `genie.bat` も削除してください。
また、後述の `genie init` コマンドで作成された各設定ディレクトリ `.genie` も気になるのであれば削除するといいです。


## init

	$ genie init

## help

	$ genie

    Usage: genie [command] <options>
    
    GENERAL    | init                     初期化 - .genieディレクトリを作成
    COMMANDS   | up                       起動 - コンテナを作成、起動済みなら再起動
               | down                     終了 - コンテナ削除
               | config                   設定内容の確認
               | config open              設定ファイル(config.pl)を標準エディタで開く
               | cli                      genieコンテナのCLIにログイン
               | cli <command>            genieコンテナ上で指定コマンド<command>実行
               | ls                       docker情報を一挙に表示
               | reject                   genie管理外のdockerコンテナも全て強制削除した後、clean実行
               | clean                    終了済みコンテナ、<none>イメージ、未参照のDataVolumeの削除
               | clean locked             `LOCKED_`から始まるDataVolumeも削除
               | php                      PHPの指定可能なバージョンリストと現在のphpenv選択バージョンの表示
               | perl                     Perlの指定可能なバージョンリストと現在のperlenv選択バージョンの表示
               | ruby                     Rubyの指定可能なバージョンリストと現在のrubyenv選択バージョンの表示
               | build                    config.pl指定のIMAGE名でビルド実行
               | build nocache            config.pl指定のIMAGE名でキャッシュを使用せずにビルド実行
               | demo                     デモモード
    
    DATABASE   | mysql <num>              MySQLコンテナのmysqlに入る（<num>で設定番号指定可）
    COMMANDS   | mysql ls <num>           MySQLの設定番号を確認する
    (default   | mysql cli <num>          MySQLコンテナのbashに入る（<num>で設定番号指定可）
     num=1)    | mysql dump <num>         MySQLのダンプを取る（<num>で設定番号指定可）
               | mysql restore <num>      MySQLのリストアを行う（<num>で設定番号指定可）
               | psql <num>               PostgreSQLコンテナのpsqlに入る（<num>で設定番号指定可）
               | psql ls <num>            PostgreSQLの設定番号を確認する
               | psql cli <num>           PostgreSQLコンテナのbashに入る（<num>で設定番号指定可）
               | psql dump <num>          PostgreSQLのダンプを取る（<num>で設定番号指定可）
               | psql restore <num>       PostgreSQLのリストアを行う（<num>で設定番号指定可）
    
    DEVELOP    | open                     ブラウザを開く
    COMMANDS   | ngrok                    ngrok起動
               | logs                     ログファイルをtailする
               | dlsync <timing of later> FTPサーバからファイルをダウンロード同期：引数無しでヘルプ表示
               | httpd                    実行パス位置でhttpdを立ち上げ（設定ファイルいらず）
               | spec <feature dir/files> Capybaraを使用したSPECテストを実行：引数無しでヘルプ表示
               | spec --all               Capybaraを使用したSPECテストを全て実行
               | zap <port/schema/url>    OWASP/ZAPコンテナを起動して脆弱性をチェック：引数無しでヘルプ表示
    
    ADD        | htop                     htop
    COMMANDS   | ll                       ls -la

