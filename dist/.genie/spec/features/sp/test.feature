# encoding: utf-8
# language: ja

機能:トップページ /

	背景:
		* 基本URLを"http://genie-xxx.com"にする
		* UAを"iphone"にする
		* ウィンドウの幅を"320"にする
		* アセット読み込み

	# ----------------------------------------------------------------------------------------------
	シナリオ:コンテンツ検証
	# ----------------------------------------------------------------------------------------------
		* ページ"/"を表示する
			* ページを検証する
				| TITLE | genie テスト      |
				| WORD  | これは genie のテストページです。 | body>h1 |
				| LINK  | PHP info          | ul#links li[0] |
				| LINK  | CGIのテストページ | ul#links li[1] |
				| LINK  | test.php          | ul#links li[2] |
			* リンクを検証する
				| PHP info          | info.php | ul#links |
				| CGIのテストページ | test.cgi | ul#links |
				| test.php          | test.php | ul#links |
			* "top.jpg"にキャプチャする
			* "わざとえらー"と表示されている
