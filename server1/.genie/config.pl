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

	# ポートバインド設定
	# ------------------
	# 未指定の場合は開いてるポートが適用されます。
	PORTS => {
		# 80   => 80,
		# 8080 => 8080,
		# 443  => 443,
		# 3306 => 3306,
		# 5432 => 5432,
	},

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
		PUBLIC_PATH => '../www',
		BANDWIDTH => '',
	},

	# Postfix設定
	# -----------
	POSTFIX => {
		FORCE_ENVELOPE => 'xxx@xxx.xxx',
	},

	# MySQL設定
	# ---------
	MYSQL => [
		# 1つめ
		{
			type => 'inner', # kazaoki/genieコンテナ内蔵のMySQLを使用
			name => 'main', # 
		},
		# 2つめ
		{
			type => 'outer', # 外部コンテナのMySQLを使用
			name=>
		},
	],

};
