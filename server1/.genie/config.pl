return {

	# Docker設定
	# ----------
	DOCKER => {
		IMAGE   => 'kazaoki/genie',
		MACHINE => 'default',
		NAME    => 'genie-test',
	},

	# ネットワーク設定
	# ----------------
	NETWORK => {
		HOSTS_ME => [
			'site.com',
			'www.site.com',
			'smtp.gmail.com',
			'mysql999.com',
			'postgresql999.com',
		],
		HOSTS_ETC => [
			# {''=>'site.com'},
		],
	},

	# ポート開放設定
	# --------------
	# '80:80'と指定することで強制バインド可能
	PORTS => [
		80,
		8080,
		443,
		3306,
		5432,
	],

	# Perl設定
	# --------
	PERL => {
		VERSION => '', # `plenv install -l` でリストアップされるバージョン文字列を指定
	},

	# Ruby設定
	# --------
	RUBY => {
		VERSION => '', # `rbenv install -l` でリストアップされるバージョン文字列を指定
	},

	# PHP設定
	# --------
	PHP => {
		VERSION => '', # `phpenv install -l` でリストアップされるバージョン文字列を指定
	},

	# Apache設定
	# ----------
	APACHE => {
		ENABLED => 1,
		PUBLIC_PATH => '../www',
		BANDWIDTH => '',
	},

	# Nginx設定
	# ----------
	NGINX => {
		ENABLED => 1,
		PUBLIC_PATH => '../www',
		BANDWIDTH => '',
	},

	# Postfix設定
	# -----------
	POSTFIX => {
		ENABLED => 1,
		FORCE_ENVELOPE => 'xxx@xxx.xxx',
	},

	# MySQL設定
	# ---------
	MYSQL => {
		ENABLED => 1,
		DATABASES => [
			{
				NAME    => 'genie_db1',
				USER    => 'genie_user1',
				PASS    => '123456789',
				CHARSET => 'UTF8',
			},
			# {
			# 	IMAGE   => 'mysql:5.5', # 外部コンテナのMySQLを利用（officialのみ対応：https://hub.docker.com/r/library/mysql/tags/）
			# 	NAME    => 'genie_db2',
			# 	USER    => 'genie_user2',
			# 	PASS    => '123456789',
			# 	CHARSET => 'UTF8',
			# },
		],
	},

	# PostgreSQL設定
	# ---------
	POSTGRESQL => {
		ENABLED => 1,
		DATABASES => [
			{
				NAME       => 'genie_db1',
				USER       => 'genie_db1',
				PASS       => '123456789',
				ENCODING   => 'utf8',
				LC_COLLATE => 'ja_JP.utf-8',
				LC_CTYPE   => 'ja_JP.utf-8',
			},
			{
				# IMAGE      => 'postgres:8.4', # 外部コンテナのPostgreSQLを利用（officialのみ対応：https://hub.docker.com/r/library/postgres/tags/）
				# NAME       => 'genie_db1',
				# USER       => 'genie_db1',
				# PASS       => '123456789',
				# ENCODING   => 'utf8',
				# LC_COLLATE => 'ja_JP.utf-8',
				# LC_CTYPE   => 'ja_JP.utf-8',
			},
		],
	},

};
