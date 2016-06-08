<?php

# -- init
ini_set("display_errors", 0);
ini_set("display_startup_errors", 0);
mb_internal_encoding('UTF-8');
error_reporting(E_ALL);

# -- config load
define('CORE_DIR', dirname(__FILE__));
require CORE_DIR.'/libraries/PHPMailer/PHPMailerAutoload.php';
require CORE_DIR.'/libraries/lib.php';
require CORE_DIR.'/config.php';
global $config;

# -- 値確画面
function check() {
	# -- バリデーションチェック
	if(!validate()) fatal_error('Input data is not correct.');
}

# -- 送信処理
function submit() {
	global $config;

	# -- バリデーションチェック
	if(!validate()) fatal_error('Input data is not correct.');

	# -- 事務局へ送信
	global $enq1_label;
	global $enq3_label;
	ob_start();
	include CORE_DIR.'/mail-templates/to_admin.php';
	$body = ob_get_clean();
	$mailer = new PHPMailer();
	$mailer->From = $_POST['mail'];
	$mailer->FromName = mb_encode_mimeheader($_POST['name1'] . ' ' . $_POST['name2']);
	$mailer->addAddress($config['admin_to'], mb_encode_mimeheader($config['admin_label']));
	$mailer->Subject  = mb_encode_mimeheader($config['admin_subject']);
	$mailer->Encoding = '7bit';
	$mailer->CharSet  = 'ISO-2022-JP';
	$mailer->Body     = mb_convert_encoding($body, 'JIS', 'UTF-8');
	$mailer->isHTML(false);
	$mailer->send();

	# -- お客様へ送信
	ob_start();
	include CORE_DIR.'/mail-templates/to_user.php';
	$body = ob_get_clean();
	$mailer = new PHPMailer();
	$mailer->From = $config['admin_to'];
	$mailer->FromName = mb_encode_mimeheader($config['admin_label']);
	$mailer->AddAddress($_POST['mail'], mb_encode_mimeheader($_POST['name1'] . ' ' . $_POST['name2']));
	$mailer->Subject  = mb_encode_mimeheader($config['user_subject']);
	$mailer->Encoding = '7bit';
	$mailer->CharSet  = 'ISO-2022-JP';
	$mailer->Body     = mb_convert_encoding($body, 'JIS', 'UTF-8');
	$mailer->isHTML(false);
	$mailer->send();

}

// -------------------------------------------------------------------
// POST値のバリデーション
// -------------------------------------------------------------------
function validate() {
	$error = 0;

	# -- 必要項目のみ全角→半角変換（ハイフン抜きはここではやらず、CSV保存時に行う）
	foreach(array(
		'mail',
		'mail2',
	) as $key){
		$_POST[$key] = mb_convert_kana(@$_POST[$key], 'a', 'UTF-8');
	}# -- POST値のチェック
	foreach(array(
		'name1',
		'name2',
		'mail',
		'mail2',
		'comment'
	) as $key){
		$error += !strlen(@$_POST[$key]);
	}
	$error += !is_email($_POST['mail']);
	$error += !is_email($_POST['mail2']);

	return !$error;

}
