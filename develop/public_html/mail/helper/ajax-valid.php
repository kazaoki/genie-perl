<?php

/**
 * Ajaxによるデータチェック
 * ------------------------
 * POSTで送信のこと。また、同ドメインからでない接続はアウト。
 * Mail Address:    /helper/ajax-valid.php?rule=EMAIL&data=hogehoge@xx.jp
 * Rakuten Account: /helper/ajax-valid.php?rule=ACCOUNT&data=1234-1234-1234-1234
 * Safe characters: /helper/ajax-valid.php?rule=SAFE&data=ほげほげほげほ
 */

# -- init
ini_set("display_errors", 0);
ini_set("display_startup_errors", 0);
mb_internal_encoding('UTF-8');
error_reporting(E_ALL);
if($_SERVER['HTTP_ORIGIN']) header('Access-Control-Allow-Origin: '.$_SERVER['HTTP_ORIGIN']);

# -- config load
define('CORE_DIR', dirname(__FILE__));
require CORE_DIR.'/libraries/lib.php';
require CORE_DIR.'/config.php';
global $config;

# -- 同ドメインからのPOSTアクセスのみ許可
if($_SERVER['REQUEST_METHOD']!='POST') fatal_error('invalid access method.');

# --プレーンテキストで出力
header('Content-type: text/plain; charset=utf-8');

# -- 楽天ポイント口座番号チェック
if($_POST['rule'] == 'ACCOUNT') {
	echo is_account($_POST['data']) ? $_POST['data'] : '';
}

# -- メールアドレスチェック
if($_POST['rule'] == 'EMAIL') {
	$email = mb_convert_kana($_POST['data'], 'a');
	echo is_email($email) ? $email : '';
}
