<?php
include 'helper/core.php';
check();
?>
<!DOCTYPE html>
<html lang="ja" id="top" prefix="og: http://ogp.me/ns#">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=2.0">
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="css/add.css">
<script src="https://code.jquery.com/jquery-2.2.4.min.js" integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44=" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="helper/core.js"></script>
</head>
<body>

<div class="container">
	<h1>testメール：確認画面</h1>
	<hr>
	<form action="done.php" method="post" id="send">
		<table class="table table-bordered table-condensed">
			<tbody>
				<tr>
					<th>氏名 <span class="label label-danger">必須</span></th>
					<td>
						<div>姓：<?php echo h(@$_POST['name1']) ?></div>
						<div>名：<?php echo h(@$_POST['name2']) ?></div>
						<input type="hidden" name="name1" value="<?php echo h(@$_POST['name1']) ?>">
						<input type="hidden" name="name2" value="<?php echo h(@$_POST['name2']) ?>">
					</td>
				</tr>
				<tr>
					<th>メールアドレス <span class="label label-danger">必須</span></th>
					<td>
						<?php echo h(@$_POST['mail']) ?>
						<input type="hidden" name="mail" value="<?php echo h(@$_POST['mail']) ?>"><br>
						<input type="hidden" name="mail2" value="<?php echo h(@$_POST['mail2']) ?>">
					</td>
				</tr>
				<tr>
					<th>文章 <span class="label label-danger">必須</span></th>
					<td>
						<?php echo nl2br(h(@$_POST['comment'])) ?>
						<?php if(!@$_POST['comment']) { ?>
						<span>（未入力）</span>
						<?php } ?>
						<input type="hidden" name="comment" value="<?php echo h(@$_POST['comment']) ?>">
					</td>
				</tr>
				</tr>
			</tbody>
		</table>
		<input type="button" class="btn btn-primary" value="&laquo; 修正する" onclick="$('form#edit').submit()">
		<input type="submit" class="btn btn-primary" value="送信 &raquo;">
	</form>
</div>

<form action="index.php?check_on_load" id="edit" method="post">
	<input type="hidden" name="name1" value="<?php echo h(@$_POST['name1']) ?>">
	<input type="hidden" name="name2" value="<?php echo h(@$_POST['name2']) ?>">
	<input type="hidden" name="mail" value="<?php echo h(@$_POST['mail']) ?>">
	<input type="hidden" name="mail2" value="<?php echo h(@$_POST['mail2']) ?>">
	<input type="hidden" name="comment" value="<?php echo h(@$_POST['comment']) ?>">
</form>

</body>
</html>
