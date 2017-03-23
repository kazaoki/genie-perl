return {

	# 起動時メモ
	# ----------
	UPMEMO => [
		# warning => 'XXX',
	],

	# Docker設定
	# ----------
	DOCKER => {
		IMAGE         => 'kazaoki/genie',
		# MACHINE       => 'sandbox',
		NAME          => 'genie-xxx',
		# OPTIONS       => '--cpuset-cpus=0-1', # `docker run` 時に渡す追加引数
		HOSTS         => [
			'genie-xxx.com:127.0.0.1',
		],
		# HOST_IP_FORCE => '192.168.99.100',
		VOLUMES => [ # ホスト側(左側)を/以外で始めるとホームパスからの指定になります。
			# 'app:/app',
			# 'home-data:/home/xxx/',
			# 'emls:/sendlog/emls',
		],
		# NO_SAY => 1, # 有効にすると音声アナウンスしなくなります。
	},

	# ブラウザ設定
	# ------------
	BROWSER => {
		OPEN_AT_UPPED => 1, # UP時にブラウザオープンするか
		OPEN_IN_PORT  => 80, # ブラウザで開きたい内部ポートを指定（自動的に外部ポートに変換されます）
		OPEN_SCHEMA   => 'http',
		OPEN_PATH     => '',
	},

	# logs設定
	# --------
	LOGS => {
		FILES => [
			# '/var/log/httpd/access_log',
			'/var/log/httpd/error_log',
			# '/var/log/httpd/ssl_access_log',
			# '/var/log/httpd/ssl_request_log',
			'/var/log/httpd/ssl_error_log',
			# '/var/log/nginx/access.log',
			# '/var/log/nginx/error.log',
		],
		# SPLIT => 2,
	},

	# Perl設定
	# --------
	PERL => {
		# VERSION => '5.12.0', # `genie perl` でリストアップされるバージョン文字列を指定
		# CPANFILE_ENABLED => 1,
	},

	# PHP設定
	# --------
	PHP => {
		# VERSION => '5.3.3', # `genie php` でリストアップされるバージョン文字列を指定
		# CONFIGURE => '--with-apxs2=/usr/bin/apxs', # `うまくいかないときは '--with-apxs2=/usr/bin/apxs --disable-fpm' など
	},

	# Ruby設定
	# --------
	RUBY => {
		# VERSION => '2.3.0', # `genie ruby` でリストアップされるバージョン文字列を指定
	},

	# Node.js設定
	# --------
	NODE => {
		# VERSION => '6.5.0', # `genie node` でリストアップされるバージョン文字列を指定
	},

	# sshd設定
	# ----------
	SSHD => {
		# ENABLED => 1,
		LOGIN_USER => 'genie',
		LOGIN_PASS => '123456789',
		LOGIN_PATH => '/mnt/host',
		BIND_PORTS => [
			'22',
		]
	},

	# Apache設定
	# ----------
	APACHE => {
		ENABLED => 1,
		PUBLIC_PATH  => 'public_html',
		# NO_CACHE     => 1,
		# BANDWIDTH    => 10000,
		NO_LOG_REGEX => '\.(gif|jpg|jpeg|jpe|png|css|js|ico)$',
		REAL_IP_LOG_ENABLED => undef,
		HTTP_PORT    => 80,
		HTTPS_PORT   => 443,
		BIND_PORTS   => [
			'80:80',
			'443:443',
		]
	},

	# Nginx設定
	# ---------
	NGINX => {
		# ENABLED => 1,
		PUBLIC_PATH => 'public_html',
		HTTP_PORT   => 8080,
		BIND_PORTS  => [
			'8080:8080',
		]
	},

	# Postfix設定
	# -----------
	POSTFIX => {
		# ENABLED => 1,
		FORCE_ENVELOPE => 'test@xx.xx',
	},

	# Sendlog設定
	# -----------
	SENDLOG => {
		ENABLED => 1, # ENABLEでも本番モードなら送信ログの保存すらしません。
		# HIDE_DESC => 1, # 一覧ページ上部の説明文を表示する(1)か否か
		BIND_PORTS   => [
			'9981:9981',
		]
	},

	# Fluentd設定
	# -----------
	FLUENTD => {
		# ENABLED => 1,
		CONFIG_FILE => '/etc/td-agent/td-agent.conf',
	},

	# MySQL設定
	# ---------
	MYSQL => {
		# ENABLED => 1,
		DATABASES => {
			main => {
				REPOSITORY => 'mysql:5.5',
				HOST       => 'db.sample',
				NAME       => 'sample_db',
				USER       => 'sample_user',
				PASS       => '123456789',
				CHARSET    => 'utf8mb4',
				COLLATION  => 'utf8mb4_unicode_ci',
				DUMP_GENEL => 3,
				# DATA_VOLUME_LOCK => 1,
				BIND_PORTS => [
					'3306'
				],
			},
		},
	},

	# PostgreSQL設定
	# --------------
	# ※LOCALEには ja_JP.UTF-8 | ja_JP.EUC-JP が指定可能で、ENCODINGはこれにより自動的に設定されます。
	POSTGRESQL => {
		# ENABLED => 1,
		DATABASES => {
			main => {
				REPOSITORY  => 'postgres:9.4',
				HOST        => 'db.sample',
				NAME        => 'sample_db',
				USER        => 'sample_user',
				PASS        => '123456789',
				LOCALE      => 'ja_JP.UTF-8',
				DUMP_GENEL  => 3,
				# DATA_VOLUME_LOCK => 1,
				BIND_PORTS  => [
					'5432:5432'
				],
			},
		},
	},

	# ngrok設定
	# ---------
	NGROK => {
		ARGS       => 'http 80',
		AUTHTOKEN  => '',
		SUBDOMAIN  => '',
		BASIC_USER => '',
		BASIC_PASS => '',
	},

	# dlsync設定
	# -----------
	DLSYNC => {
		REMOTE_HOST  => '', # ポート指定したい場合は `(ホスト):(ポート)` のように指定可能です。
		REMOTE_USER  => '',
		REMOTE_PASS  => '',
		REMOTE_DIR   => '/public_html',
		LOCAL_DIR    => 'public_html', # ホームパスからの相対です
		# REMOTE_CHARSET => 'utf8', # utf8, sjis 等
		# LOCAL_CHARSET  => 'sjis',
		LFTP_OPTION  => '--verbose --delete -X .genie -X .git*', # mirror時のオプション（http://lftp.yar.ru/lftp-man.html）
		DEFAULT_ARGV => '', # `genie dlsync`の引数が無い時の引数を指定できます。
	},

	# SPEC設定
	# --------
	SPEC => {
		DEFAULT_CAPTURE_WIDTH => 1280,
		DEFAULT_USER_AGENT    => '',
		JS_ERRORS             => 0,
		SILENT_FAST           => 1,  # 1にするとfastモード時に実行するか否か聞いてこないように
		NO_SENDMAIL           => 1,  # 1にするとSPEC中はメール送信を行いません。（但し、/sendlogには記録されます）
	},

	# ZAP設定
	# -------
	ZAP => {
		NO_SENDMAIL           => 1,  # 1にするとZAP中はメール送信を行いません。（但し、/sendlogには記録されます）
	},

	# 追加コマンド設定
	# ----------------
	ADD_COMMAND => {
		# htop => 'htop',
		# ll => 'ls -la',
	},

};
