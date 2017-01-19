return {

	# 起動時メモ
	# ----------
	UPMEMO => [
		warning => 'ほんばんもーどのてすとでっせ！',
	],

	# Docker設定
	# ----------
	DOCKER => {
		# NETWORK => 'my_docker_nw',
	},

	# Apache設定
	# ----------
	APACHE => {
		BIND_PORTS => undef,
	},

	# Fluentd設定
	# -----------
	FLUENTD => {
		CONFIG_FILE => '/etc/td-agent/td-agent-product.conf',
	},

	# MySQL設定
	# ---------
	MYSQL => {
		DATABASES => {
			main => {
				DATA_VOLUME_LOCK => 1,
				BIND_PORTS  => undef,
			},
		},
	},
};
