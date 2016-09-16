<?php
require_once 'Mail/mimeDecode.php';

$dir = '/sendlog/emls';

// -- クリアモード
if(@$_GET['clear']){
	array_map('unlink', glob($dir.'/*.eml'));
	header('Location: ' . @$_SERVER['PHP_SELF']);
}

// -- developモードでしか機能しないよう
if(getenv('GENIE_GENERAL_RUNMODE')!='develop') throw new Exception();

// -- emlファイル一覧を取得（数値の大きな順）
$files = array();
foreach(scandir($dir, SCANDIR_SORT_DESCENDING ) as $file){
	if(preg_match('/\.eml$/', $file)){
		$mail = parseMail("$dir/".$file);
		# ちゃんと「@」入ってる宛先なら表示対象にする（cronの結果メールとかは`root`だけだったりするので無視）
		if(mb_strpos($mail['to'], '@')!==false) array_push($files, $file);
	}
}

# --  必要なメールデータのパース
if(@$_GET['last']!='') {
	# -- 詳細の場合
	if(!$_GET['last']>0) $_GET['last'] = 1;
	$detail = parseMail("$dir/".$files[$_GET['last']-1]);
} else {
	# -- 一覧の場合
	foreach($files as $file){
		$mail = parseMail("$dir/".$file);
		$list[] = $mail;
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
		'decode_headers' => false, // ヘッダをデコードするかどうか。→自前でデコードします
		'input'          => file_get_contents($file),
		'crlf'           => "\r\n", // 行末を指定する。
	));

	# -- 解析結果用の入れ物
	$info = array();

	$info['subject'] = mb_decode_mimeheader(@$mail->headers['subject']);
	$info['from']    = mb_decode_mimeheader(@$mail->headers['from']);
	$info['to']      = mb_decode_mimeheader(@$mail->headers['to']);
	$info['date']    = @$mail->headers['date'];
	$keys = array_keys($mail->headers);
	sort($keys);
	foreach($keys as $key) {
		$line = sprintf("%s: %s\n", $key, mb_decode_mimeheader(@$mail->headers[$key]));
		if(in_array($key, array('to', 'from', 'subject'))){
			$info[$key] = preg_replace('/(?<! )</', ' <', $info[$key]);
			$line = preg_replace('/(?<! )</', ' <', $line);
		}
		@$info['headers'] .= $line;
	}

	# -- 入れ子解析
	$info = analyzePart($mail, $info);

	# -- FromとToの<>ラベルの前に空白を入れる作業
	mb_regex_encoding('UTF-8');

	# -- 返却
	return $info;
}

// -------------------------------------------------------------------
// 入れ子パート解析用の再帰関数
// -------------------------------------------------------------------
function analyzePart($part, $info){
	switch(strtolower($part->ctype_primary)){
		case 'text':
			if($part->ctype_secondary=='plain') {
				$info['body'] = $part->body;
				if($part->ctype_parameters['charset']){
					$encode = $part->ctype_parameters['charset'];
					$info['encode'] = $encode;
					// auto link
					$info['body'] = preg_replace_callback(
						"~[[:alpha:]]+://[^<>[:space:]]+[[:alnum:]/]~",
						function($matches){
							static $count = 0;
							return "<a href=\"$matches[0]\" class=\"link-url-".(++$count)."\">$matches[0]</a>";
						},
						h(mb_convert_encoding($info['body'], 'UTF-8', $encode))
					);
				}
			} else if($part->ctype_secondary=='html') {
				$info['html'] = $part->body;
			}
			break;
		case 'multipart':
			foreach($part->parts as $inpart){
				$info = analyzePart($inpart, $info);
			}
			break;
		case 'image':
		case 'application':
			$info['attach'][] = array(
				'filename' => mb_decode_mimeheader($part->ctype_parameters['name']),
				'is_image' => ($part->ctype_primary=='image'),
				'base64'   => sprintf('data:%s/%s;base64,%s', $part->ctype_primary, $part->ctype_secondary, base64_encode($part->body)),
				'kb'       => number_format(ceil(strlen($part->body)/1024)),
			);
			break;
	}
	return $info;
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
	<h1><a href="/">Sendlog <small>sendmail sent logs <i>[<?php echo getenv('GENIE_DOCKER_NAME') ?>]</i></small></a></h1>

<?php if(!@$_GET['last']) { ?>

	<div class="panel panel-default">
		<div class="panel-body">
			<p>
				<code>sendmail</code> コマンドにて送信されたメールのログです。spec等の送信メールの内容チェックにご利用いただけます。
			</p>
			<table class="table table-bordered table-striped table-condensed">
				<thead>
					<tr>
						<th>関連する環境変数名</th>
						<th>現在の値</th>
						<th>説明</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>GENIE_GENERAL_RUNMODE</td>
						<td><?php echo getenv('GENIE_GENERAL_RUNMODE') ?></td>
						<td><code>develop</code> の場合にのみ、この画面が表示されます。</td>
					</tr>
					<tr>
						<td>GENIE_POSTFIX_ENABLED</td>
						<td><?php echo getenv('GENIE_POSTFIX_ENABLED') ?></td>
						<td><code>1</code> の場合、sendmailを通したメール送信が実行されます。</td>
					</tr>
					<tr>
						<td>GENIE_POSTFIX_FORCE_ENVELOPE</td>
						<td><?php echo getenv('GENIE_POSTFIX_FORCE_ENVELOPE') ?></td>
						<td>この設定したメールアドレスに強制的に配送されます。</td>
					</tr>
					<tr>
						<td>GENIE_SENDLOG_ENABLED</td>
						<td><?php echo getenv('GENIE_SENDLOG_ENABLED') ?></td>
						<td><code>1</code> の場合、この画面が表示できます。</td>
					</tr>
					<tr>
						<td>GENIE_SENDLOG_BIND_PORTS</td>
						<td><?php echo getenv('GENIE_SENDLOG_BIND_PORTS') ?></td>
						<td>この画面にアクセスするためのポート指定です。docker のポート指定にもそのまま使用されますので、 <code>AAAA:BBBB</code> のようなカンマ区切りの指定も可能です。</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
<?php } ?>

	<section>

<?php if(@$list) { ?>

	<div class="text-right">
		<a href="./?clear=1" onClick="if(confirm('本当に削除しますか？')){;}else{return false;}">送信ログを全て削除する</a>
	</div>
	<h2>list</h2>
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
			<?php $count=0; foreach(@$list as $mail) { ++$count ?>
			<tr id="last-<?php echo $count ?>">
				<td class="count"><?php echo $count ?></td>
				<td class="subject"><a href="/?last=<?php echo $count ?>"><?php echo h(@$mail['subject']) ?></a></td>
				<td class="from"><small><?php echo h(@$mail['from']) ?></small></td>
				<td class="to"><small><?php echo h(@$mail['to']) ?></small></td>
				<td class="date"><small><?php echo h(@$mail['date']) ?></small></td>
			</tr>
			<?php } ?>
		</tbody>
	</table>

<?php } else if (@$detail) { ?>

	<h2>detail</h2>
	<div class="panel panel-default">
		<div class="panel-heading">
			<p class="pull-right">
				<span id="date" class="btn btn-default disabled" style="cursor:default">
					<?php echo @$detail['date'] ?>
				</span>
			</p>
			<h4 id="subject"><?php echo h(@$detail['subject']) ?></h4>
		</div>
		<div class="panel-body">
			<div class="text-center">
				<span id="from"><?php echo h(@$detail['from']) ?></span>
				&nbsp;
				<i class="fa fa-arrow-right fa-2x text-info" aria-hidden="true" style="vertical-align:middle"></i>
				&nbsp;
				<span id="to"><?php echo h(@$detail['to']) ?></span>
			</div>
		</div>
		<table class="table" id="attach">
			<thead>
				<tr>
					<td>
						<dl class="dl-horizontal">
							<dt>SUBJECT</dt>
							<dd id="SUBJECT"><?php echo h(@$detail['subject']) ?></dd>
							<dt>FROM</dt>
							<dd id="FROM"><?php echo h(@$detail['from']) ?></dd>
							<dt>TO</dt>
							<dd id="TO"><?php echo h(@$detail['to']) ?></dd>
							<dt>DATE</dt>
							<dd id="DATE"><?php echo h(@$detail['date']) ?></dd>
							<dt>BODY</dt>
							<dd id="BODY">
								<?php if(@$detail['body']){ ?>
									<pre style="white-space: pre-wrap;">
<?php echo @$detail['body'] ?></pre>
								<?php } else { ?>
									<span class="text-muted">(undef)</span>
								<?php } ?>
							</dd>
							<?php if(@$detail['html']!='') { ?>
							<dt>HTML</dt>
							<dd id="HTML"><pre style="white-space: pre-wrap;"><?php echo h(@$detail['html']) ?></pre></dd>
							<?php } ?>
							<dt>HEADER</dt>
							<dd id="HEADER"><pre style="white-space: pre-wrap;"><?php echo h(@$detail['headers']) ?></pre></dd>
							<?php if(@$detail['attach']!='') { ?>
							<dt>ATTACH</dt>
							<dd id="ATTACH">
								<ul>
								<?php foreach(@$detail['attach'] as $attach) { ?>
									<li>
										<a href="<?php echo @$attach['base64'] ?>" download="<?php echo @$attach['filename'] ?>">
											<?php echo @$attach['filename'] ?>
											<small>(<?php echo @$attach['kb'] ?>kb)</small>
											<?php if(@$attach['is_image']) { ?><img src="<?php echo @$attach['base64'] ?>" class="img-thumbnail" style="max-width:100px;max-height:100px;"><?php } ?>
										</a>
									</li>
								<?php } ?>
								</ul>
							</dd>
							<?php } ?>
						</dl>
					</td>
				</tr>
			</thead>
		</table>
	</div>

<?php } else { ?>

	<div class="well">
		<code>sendmail</code> を通したメール送信ログはまだありません。
	</div>

<?php } ?>
	</section>
</div>

</body>
</html>
