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
			# 内部コンテナのMySQLを利用
			{
				NAME => genie_db1,
				USER => genie_user1,
				PASS => 123456789,
				# HOSTNAME_TO_LOCAL => mysql999.db.com,
				CHARSET => UTF8,
			},
			# 外部コンテナのMySQLを利用（officialのみ対応：https://hub.docker.com/_/mysql/）
			{
				IMAGE => 'mysql:5.5',
				NAME => genie_db2,
				USER => genie_user2,
				PASS => 123456789,
				# HOSTNAME_TO_LOCAL => mysql999.db.com,
				CHARSET => UTF8,
			},
		],
		# -- 外部MySQLコンテナ起動（officialのみ対応：https://hub.docker.com/_/mysql/）
		OUTER_DBS => [
			# 1つめ
			{
				IMAGE => 'mysql:5.5',
				NAME => genie_db1,
				USER => genie_user1,
				PASS => 123456789,
				# HOSTNAME_TO_LOCAL => mysql999.db.com,
				CHARSET => UTF8,
			},
			# 2つめ
			{
				IMAGE => 'mysql:5.5',
				NAME => genie_db2,
				USER => genie_user2,
				PASS => 123456789,
				# HOSTNAME_TO_LOCAL => mysql999.db.com,
				CHARSET => UTF8,
			},
		],
	},


# # [PostgreSQL]
# LAMP_PGSQL=0
# LAMP_PGSQL_DB=lamp
# LAMP_PGSQL_USER=lamp
# LAMP_PGSQL_PASS=123456
# LAMP_PGSQL_PORT=5432:5432
# # LAMP_PGSQL_HOSTNAME_TO_LOCAL=pgsql3.db
# LAMP_PGSQL_ENCODING=utf8
# LAMP_PGSQL_LC_COLLATE=ja_JP.utf-8
# LAMP_PGSQL_LC_CTYPE=ja_JP.utf-8


};
