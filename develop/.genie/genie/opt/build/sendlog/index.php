<?php
require_once 'Mail/mimeDecode.php';

$dir = '/sendlog';

// -- developモードでしか機能しないよう
if(getenv('GENIE_GENERAL_RUNMODE')!='develop') throw new Exception();

// -- emlファイル一覧を取得（数値の大きな順）
$files = array();
foreach(scandir($dir, SCANDIR_SORT_DESCENDING ) as $file){
	if(preg_match('/\.eml$/', $file)){
		array_push($files, $file);
	}
}

# --  必要なメールデータのパース
if($_GET['last']!='') {
	# -- 詳細の場合
	if(!$_GET['last']>0) $_GET['last'] = 1;
	$detail = parseMail($files[$_GET['last']-1]);
} else {
	# -- 一覧の場合
	foreach($files as $file){
		$list[] = parseMail($file);
	}
}

// -------------------------------------------------------------------
// メールデータパース
// -------------------------------------------------------------------
function parseMail($file){
	# -- パース
	$mail = Mail_mimeDecode::decode(array(
		'include_bodies' => true, // 返される構造体にbody(本文)を含めるどうか。
		'decode_bodies'  => true, // 返されるbodyをデコードするかどうか。
		'decode_headers' => true, // ヘッダをデコードするかどうか。
		'input'          => file_get_contents($file),
		'crlf'           => "\r\n", // 行末を指定する。
	));
	# -- 調整
	if(preg_match('/charset=(.+)$/', $mail->headers['content-type'], $mathes)){
		$mail->charset = $mathes[1];
		$mail->headers['subject'] = mb_convert_encoding($mail->headers['subject'], 'UTF-8', $mathes[1]);
		$mail->headers['from']    = mb_convert_encoding($mail->headers['from'], 'UTF-8', $mathes[1]);
		$mail->headers['to']      = mb_convert_encoding($mail->headers['to'], 'UTF-8', $mathes[1]);
		$mail->body               = mb_convert_encoding($mail->body, 'UTF-8', $mathes[1]);
	}
	# -- 返却
	return $mail;
}

// -------------------------------------------------------------------
// サニタイズ
// -------------------------------------------------------------------
function h($str) {
	return htmlspecialchars($str, ENT_QUOTES, 'UTF-8');
}

?>
<!DOCTYPE html>
<html lang="ja" id="top" prefix="og: http://ogp.me/ns#">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=2.0">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-2.2.4.min.js" integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44=" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</head>
<body>

<div class="container">
	<h1><a href="/">sendmail sent logs</a></h1>
	<div class="panel panel-default">
	  <div class="panel-body">
	  	<code>sendmail</code> にて送信されたメールのログです。この画面は環境変数 <code>GENIE_GENERAL_RUNMODE</code> が <code>develop</code> の時のみに閲覧できます。
	  </div>
	</div>
	<hr>
	<section>

<?php if($list) { ?>

	<!-- 一覧 -->
	<h2>一覧</h2>
	<table class="table table-bordered">
		<thead>
			<tr>
				<th>last</th>
				<th>Subject</th>
				<th>From</th>
				<th>To</th>
				<th>Date</th>
			</tr>
		</thead>
		<tbody>
			<?php foreach($list as $mail) { ++$count ?>
			<tr id="last-<?php echo $count ?>">
				<td class="count"><?php echo $count ?></td>
				<td class="subject"><a href="/?last=<?php echo $count ?>"><?php echo h($mail->headers['subject']) ?></a></td>
				<td class="from"><small><?php echo h($mail->headers['from']) ?></small></td>
				<td class="to"><small><?php echo h($mail->headers['to']) ?></small></td>
				<td class="date"><small><?php echo h($mail->headers['date']) ?></small></td>
			</tr>
			<?php } ?>
		</tbody>
	</table>

<?php } else if ($detail) { ?>

<?php
// var_dump($detail); exit;
?>


	<!-- 詳細 -->
	<h2>詳細</h2>
	<div class="panel panel-default">
		<div class="panel-heading">
			<p class="pull-right">
				<span id="date" class="btn btn-default disabled" style="cursor:default">
					<?php echo $detail->headers['date'] ?>
				</span>
			</p>
			<h4 id="subject"><?php echo h($detail->headers['subject']) ?></h4>
		</div>
		<div class="panel-body">
			<div class="text-center">
				<span id="from"><?php echo h($detail->headers['from']) ?></span>
				&nbsp;
				<i class="fa fa-arrow-right fa-2x text-info" aria-hidden="true" style="vertical-align:middle"></i>
				&nbsp;
				<span id="to"><?php echo h($detail->headers['to']) ?></span>
			</div>
			<hr>
			<pre class="col-md-8" id="body"><?php echo h($detail->body) ?></pre>
			<pre class="col-md-4" id="headers">(headers)</pre>
		</div>
		<table class="table" id="attach">
			<thead>
				<tr>
					<td>
						添付ファイル
						（実装未だ）
					</td>
				</tr>
			</thead>
		</table>
	</div>

<?php } ?>
	</section>
</div>

</body>
</html>
