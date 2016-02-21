return {

	# DATA_SCALAR => 123,
	# DATA_ARRAY => [1,2,3],
	# DATA_HASH => {
	# 	UNDER1=>1,
	# 	UNDER2=>2,
	# 	UNDER3=>3,
	# },

	# Docker設定
	# ----------
	DOCKER => {
		IMAGE         => 'kazaoki/genie',
		MACHINE       => '',
		NAME          => 'genie-test',
		OPTIONS       => '--cpuset-cpus=0-1', # `docker run` 時に渡す追加引数
		OPTIONS_BUILD => '--cpuset-cpus=0-1', # `docker build` 時に渡す追加引数
		HOSTS_ME      => [
			'site.com',
			'www.site.com',
			'smtp.gmail.com',
			'mysql999.com',
			'postgresql999.com',
		],
		HOSTS_ETC     => [
			'8.8.8.8:dns.google',
		],
		PORTS         => [
			80,
			8080,
			443,
			3306,
			'5432:5432',
		],
	},

	# Perl設定
	# --------
	PERL => {
		# VERSION => '5.12.0', # `plenv install -l` でリストアップされるバージョン文字列を指定
		# CPANFILE_ENABLED => 1,
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
		PUBLIC_PATH => 'public_html',
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
		# ENABLED => 1,
		FORCE_ENVELOPE => 'test@kazaoki.jp',
	},

	# MySQL設定
	# ---------
	MYSQL => {
		# ENABLED => 1,
		DATABASES => [
			{
				REPOSITORY   => 'mysql:5.6',
				NAME         => 'genie_db1',
				USER         => 'genie_user1',
				PASS         => '123456789',
				PORT         => '13306',
				CHARSET      => 'utf8',
			},
			{
				REPOSITORY   => 'mysql:5.6',
				NAME         => 'genie_db2',
				USER         => 'genie_user2',
				PASS         => '123456789',
				PORT         => '13306',
				CHARSET      => 'utf8',
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
				REPOSITORY => 'postgres:9.4',
				NAME       => 'genie_db1',
				USER       => 'genie_user1',
				PASS       => '123456789',
				PORT       => '55432',
				LOCALE     => 'ja_JP.UTF-8',
			},
			{
				REPOSITORY => 'postgres:9.3',
				NAME       => 'genie_db2',
				USER       => 'genie_user2',
				PASS       => '123456789',
				PORT       => '55432',
				LOCALE     => 'ja_JP.UTF-8',
			},
		],
	},

};
