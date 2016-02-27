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
		PUBLIC_PATH     => 'public_html',
		HOST_PORT_HTTP  => '80',
		HOST_PORT_HTTPS => '443',
		# BANDWIDTH   => 100,
		# NO_CACHE    => 1,
	},

	# Nginx設定
	# ----------
	NGINX => {
		# ENABLED => 1,
	},

	# Postfix設定
	# -----------
	POSTFIX => {
		ENABLED => 1,
		FORCE_ENVELOPE => 'test@kazaoki.jp',
	},

	# MySQL設定
	# ---------
	MYSQL => {
		ENABLED => 1,
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
			# 	# HOST_PORT  => '3308',
			# },
			# {
			# 	LABEL      => 'db2',
			# 	REPOSITORY => 'mysql:5.6',
			# 	HOST       => 'db2.kazaoki.jp',
			# 	NAME       => 'genie_db2',
			# 	USER       => 'genie_user2',
			# 	PASS       => '123456789',
			# 	CHARSET    => 'utf8',
			# 	DUMP_GENEL => 3,
			# 	PORT       => '23306',
			# 	# HOST_PORT  => '3309',
			# },
			# {
			# 	LABEL      => 'db3',
			# 	REPOSITORY => 'mysql:5.7',
			# 	HOST       => 'db3.kazaoki.jp',
			# 	NAME       => 'genie_db3',
			# 	USER       => 'genie_user3',
			# 	PASS       => '123456789',
			# 	CHARSET    => 'utf8',
			# 	DUMP_GENEL => 3,
			# 	PORT       => '23306',
			# 	# HOST_PORT  => '3310',
			# },
			{
				LABEL      => 'wp',
				REPOSITORY => 'mysql:5.7',
				HOST       => 'db-wp.kazaoki.jp',
				NAME       => 'wp',
				USER       => 'wp',
				PASS       => '123456',
				CHARSET    => 'utf8',
				DUMP_GENEL => 3,
				PORT       => '13306',
				HOST_PORT  => '3306',
			},
		],
	},

	# PostgreSQL設定
	# --------------
	# ※LOCALEには ja_JP.UTF-8 | ja_JP.EUC-JP が指定可能で、ENCODINGはこれにより自動的に設定されます。
	POSTGRESQL => {
		ENABLED => 1,
		DATABASES => [
			{
				LABEL      => 'db1',
				REPOSITORY => 'postgres:9.4',
				HOST       => 'db1.com',
				NAME       => 'genie_db1',
				USER       => 'genie_user1',
				PASS       => '123456789',
				LOCALE     => 'ja_JP.UTF-8',
				DUMP_GENEL => 3,
				PORT       => '54321',
				HOST_PORT  => '5432',
			},
			{
				LABEL      => 'test-db',
				REPOSITORY => 'postgres:9.3',
				# HOST       => 'localhost',
				NAME       => 'genie_db2',
				USER       => 'genie_user2',
				PASS       => '123456789',
				LOCALE     => 'ja_JP.UTF-8',
				DUMP_GENEL => 3,
				PORT       => '55432',
				# HOST_PORT  => '5432',
			},
		],
	},

};
