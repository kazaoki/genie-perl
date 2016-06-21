# encoding: utf-8
# language: ja

機能:トップページ /

	背景:
		* 基本URLを"http://genie-xxx.com"にする
		* UAを"default"にする
		* ウィンドウの幅を"default"にする
		* アセット読み込み

	# ----------------------------------------------------------------------------------------------
	シナリオ:コンテンツ検証
	# ----------------------------------------------------------------------------------------------
		* ページ"/"を表示する
			* ページを検証する
				| TITLE | genie テスト      |
				| WORD  | これは genie のテストページです。 | body>h1 |
				| LINK  | PHP info          | ul#links |
				| LINK  | CGIのテストページ | ul#links |
				| LINK  | test.php          | ul#links |
			* リンクを検証する
				| PHP info          | info.php | ul#links li[0] |
				| CGIのテストページ | test.cgi | ul#links li[1] |
				| test.php          | test.php | ul#links li[2] |
			* "top.jpg"にキャプチャする
			* "わざとえらー"と表示されている
