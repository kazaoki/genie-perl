# encoding: utf-8
# language: ja

機能:トップページ /

	シナリオ:基本URLを設定する
		# * 基本URLを"http://genie-test.com"にする
		* 基本URLを"http://localhost"にする

	# ----------------------------------------------------------------------------------------------
	シナリオ:コンテンツ検証
	# ----------------------------------------------------------------------------------------------
		* ページ"/"を表示する
			* ページを検証する
				| タイトル | genie テスト |
				| ワード   | これは genie のテストページです。 | body>h1 |
				| リンク   | PHP info          | ul#links |
				| リンク   | CGIのテストページ | ul#links |
				| リンク   | WordPressテスト   | ul#links |
			* リンクを検証する
				| PHP info          | info.php | ul#links |
				| CGIのテストページ | test.cgi | ul#links |
				| WordPressテスト   | /wp/     | ul#links |
