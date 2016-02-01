return {

	# Docker設定
	# ----------
	DOCKER => {
		IMAGE   => 'kazaoki/lamp',
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

};
