return {

	# 起動時メモ
	# ----------
	UPMEMO => [
		warning => '本番モードです',
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
		REAL_IP_LOG_ENABLED => 1,
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
