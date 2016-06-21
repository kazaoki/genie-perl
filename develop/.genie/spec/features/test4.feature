# encoding: utf-8
# language: ja

機能:トップページ /

	背景:
		* 基本URLを"http://genie-test.com"にする
		* UAを"default"にする
		* ウィンドウの幅を"default"にする
		* アセット読み込み

	# ----------------------------------------------------------------------------------------------
	シナリオ:コンテンツ検証
	# ----------------------------------------------------------------------------------------------
		* ページ"/"を表示する
		* "CGIのテストページ"と表示されている @"ul#links li[1]"
		* ページを検証する
			| WORD | PHP info                          | ul#links li[0] |
			| WORD | CGIのテストページ                 | ul#links li[1] |
			| WORD | WordPressテスト                   | ul#links li[2] |
			| WORD | test.php                          | ul#links li[3] |
			| WORD | 別ウィンドウGoogle                | ul#links li[4] |
			| WORD | メール送信テストフォーム          | ul#links li[5] |
			| WORD | Sendlog                           | ul#links li[6] |
