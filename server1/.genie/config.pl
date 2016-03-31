return {

	# Docker設定
	# ----------
	DOCKER => {
		IMAGE         => 'kazaoki/genie',
		# MACHINE       => 'sandbox',
		NAME          => 'genie-test',
		OPTIONS       => '--cpuset-cpus=0-1', # `docker run` 時に渡す追加引数
		OPTIONS_BUILD => '--cpuset-cpus=0-1', # `docker build` 時に渡す追加引数
		HOSTS         => [
			'genie.kazaoki.jp:127.0.0.1',
		],
		# HOST_IP_FORCE => '192.168.99.100',
		VOLUMES => [ # ホスト側(左側)を/以外で始めるとホームパスからの指定になります。
			# 'app:/app',
			# 'home-data:/home/xxx/',
		],
	},

	# ブラウザ設定
	# ------------
	BROWSER => {
		OPEN_AT_UPPED => 1, # UP時にブラウザオープンするか
		OPEN_IN_PORT  => 80, # ブラウザで開きたい内部ポートを指定（自動的に外部ポートに変換されます）
		OPEN_SCHEMA   => 'http',
	},

	# logs設定
	# --------
	LOGS => {
		FILES => [
			'/var/log/httpd/access_log',
			'/var/log/httpd/error_log',
			# '/var/log/httpd/ssl_access_log',
			# '/var/log/httpd/ssl_request_log',
			# '/var/log/httpd/ssl_error_log',
			# '/var/log/nginx/access.log',
			# '/var/log/nginx/error.log',
		],
	},

	# Perl設定
	# --------
	PERL => {
		VERSION => '5.12.0', # `plenv install -l` でリストアップされるバージョン文字列を指定
		CPANFILE_ENABLED => 1,
	},

	# PHP設定
	# --------
	PHP => {
		# VERSION => '5.6.0', # `phpenv install -l` でリストアップされるバージョン文字列を指定
	},

	# Ruby設定
	# --------
	RUBY => {
		# VERSION => '2.3.0', # `rbenv install -l` でリストアップされるバージョン文字列を指定
	},

	# Apache設定
	# ----------
	APACHE => {
		ENABLED => 1,
		PUBLIC_PATH => 'public_html',
		NO_CACHE    => 1,
		# BANDWIDTH   => 100,
		HTTP_PORT   => 80,
		HTTPS_PORT  => 443,
		BIND_PORTS  => [
			'80:80',
			'443:443',
		]
	},

	# Nginx設定
	# ---------
	NGINX => {
		# ENABLED => 1,
		PUBLIC_PATH => 'public_html/test',
		HTTP_PORT   => 8080,
		BIND_PORTS  => [
			'8080:8080',
		]
	},

	# Postfix設定
	# -----------
	POSTFIX => {
		# ENABLED => 1,
		FORCE_ENVELOPE => 'test@kazaoki.jp',
	},

	# MySQL設定
	# ---------
	MYSQL => {
		# ENABLED => 1,
		DATABASES => [
			# {
			# 	LABEL      => 'db1',
			# 	REPOSITORY => 'mysql:5.5',
			# 	HOST       => 'db1.kazaoki.jp',
			# 	NAME       => 'genie_db1',
			# 	USER       => 'genie_user1',
			# 	PASS       => '123456789',
			# 	CHARSET    => 'utf8',
			# 	DUMP_GENEL => 3,
			# 	PORT       => '13306',
			# 	BIND_PORTS => [
			# 		'3308:13306'
			# 	],
			# },
			# {
			# 	LABEL      => 'db2',
			# 	REPOSITORY => 'mysql:5.6',
			# 	HOST       => 'db2.kazaoki.jp',
			# 	NAME       => 'genie_db2',
			# 	USER       => 'genie_user2',
			# 	PASS       => '123456789',
			# 	CHARSET    => 'utf8',
			# 	DUMP_GENEL => 1,
			# 	PORT       => '23306',
			# 	BIND_PORTS => [
			# 		'3309:23306'
			# 	],
			# },
			# {
			# 	LABEL      => 'db3',
			# 	REPOSITORY => 'mysql:5.7',
			# 	HOST       => 'db3.kazaoki.jp',
			# 	NAME       => 'genie_db3',
			# 	USER       => 'genie_user3',
			# 	PASS       => '123456789',
			# 	CHARSET    => 'utf8',
			# 	DUMP_GENEL => 1,
			# 	PORT       => '23306',
			# 	BIND_PORTS => [
			# 		'3310:23306'
			# 	],
			# },
			{
				LABEL      => 'wp',
				REPOSITORY => 'mysql:5.7',
				HOST       => 'db-wp.kazaoki.jp',
				NAME       => 'wp',
				USER       => 'wp',
				PASS       => '123456',
				CHARSET    => 'utf8',
				DUMP_GENEL => 2,
				PORT       => '13306',
				BIND_PORTS => [
					'13306'
				],
			},
		],
	},

	# PostgreSQL設定
	# --------------
	# ※LOCALEには ja_JP.UTF-8 | ja_JP.EUC-JP が指定可能で、ENCODINGはこれにより自動的に設定されます。
	POSTGRESQL => {
		# ENABLED => 1,
		DATABASES => [
			# {
			# 	LABEL      => 'db1',
			# 	REPOSITORY => 'postgres:9.4',
			# 	HOST       => 'db1.com',
			# 	NAME       => 'genie_db1',
			# 	USER       => 'genie_user1',
			# 	PASS       => '123456789',
			# 	LOCALE     => 'ja_JP.UTF-8',
			# 	DUMP_GENEL => 3,
			# 	PORT       => '54321',
			# 	BIND_PORTS => [
			# 		'5432:54321'
			# 	],
			# },
			{
				LABEL      => 'test-db',
				REPOSITORY => 'postgres:9.3',
				# HOST       => 'localhost',
				NAME       => 'genie_db2',
				USER       => 'genie_user2',
				PASS       => '123456789',
				LOCALE     => 'ja_JP.UTF-8',
				DUMP_GENEL => 1,
				PORT       => '55432',
				BIND_PORTS => [
					'55432'
				],
			},
		],
	},

	# ngrok設定
	# ---------
	NGROK => {
		AUTHTOKEN => '',
		SUBDOMAIN => '',
	},

	# ftpsync設定
	# -----------
	FTPSYNC => {
		REMOTE_HOST  => '',
		REMOTE_USER  => '',
		REMOTE_PASS  => '',
		REMOTE_DIR   => '/public_html',
		LOCAL_DIR    => 'public_html', # ホームパスからの相対です
		LFTP_CHARSET => 'utf8', # utf8, sjis 等
		# -- mirror時のオプション（http://lftp.yar.ru/lftp-man.html）
		LFTP_OPTION  => '--verbose --delete',
		# LFTP_OPTION  => '--verbose --delete --only-newer', # 新しいタイムスタンプのファイルのみDL（gitブランチ切り替えなどでローカルファイルが新しくなるので注意）
		# LFTP_OPTION  => '--verbose --delete --ignore-time', # サイズが違うファイルのみDL（変更有りでも同サイズの場合があるので注意）
		# LFTP_OPTION  => '--verbose --delete --newer-than=now-10days', # 10日前からのファイルを同期
		LFTP_NEWER_THAN_LAST_COMMIT => 1, # この値が1ならば、現在のgitコミットの最終日から変更されたファイルのみをダウンロード対象にします。（--newer-than=now-XXdays の日付を自動算出します）
	},

};
