# encoding: utf-8
# language: ja

機能:トップページ /

	シナリオ:基本URLを設定する
		* 基本URLを"http://genie-test.com"にする

	# ----------------------------------------------------------------------------------------------
	シナリオ:自動キャプチャ設定
	# ----------------------------------------------------------------------------------------------
		* ページ"/"を表示する
		* "PHP info"をクリックする
		* 戻る
		* "CGIのテストページ"をクリックする
		* 戻る
		* "WordPressテスト"をクリックする
		* 戻る
		* ページ"http://kazaoki.jp/tools/env/"を表示する
