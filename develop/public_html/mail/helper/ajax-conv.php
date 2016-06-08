<?php

/**
 * Ajaxによるデータ変換
 * ------------------------
 * POSTで送信のこと。また、同ドメインからでない接続はアウト。
 * Mail Address:    /helper/ajax-conv.php?string=ｶｶｶﾞ&option=KV -> カカガ
 */

# -- init
ini_set("display_errors", 0);
ini_set("display_startup_errors", 0);
mb_internal_encoding('UTF-8');
error_reporting(E_ALL);
if($_SERVER['HTTP_ORIGIN']) header('Access-Control-Allow-Origin: '.$_SERVER['HTTP_ORIGIN']);

# -- config load
define('SYSTEM_DIR', dirname(__FILE__));
require SYSTEM_DIR.'/libraries/lib.php';
require SYSTEM_DIR.'/config.php';
global $config;

# -- 同ドメインからのPOSTアクセスのみ許可
if($_SERVER['REQUEST_METHOD']!='POST') fatal_error('invalid access method.');

# -- 変換してプレーンテキストで返却
header('Content-type: text/plain; charset=utf-8');
echo mb_convert_kana($_POST['string'], $_POST['option']);

exit;
