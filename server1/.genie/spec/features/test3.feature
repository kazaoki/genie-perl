# encoding: utf-8
# language: ja

機能:トップページ /

	シナリオ:基本URLを設定する
		* 基本URLを"http://genie-test.com"にする

	# ----------------------------------------------------------------------------------------------
	シナリオ:コンテンツ検証
	# ----------------------------------------------------------------------------------------------
		* ページ"/"を表示する
			* cap
			* "別ウィンドウGoogle"をクリックする
			* 最後に開いたウィンドウに移動する
			* cap
