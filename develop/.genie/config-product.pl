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
