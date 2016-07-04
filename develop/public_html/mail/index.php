<?php
include 'helper/core.php';
?>
<!DOCTYPE html>
<html lang="ja" id="top" prefix="og: http://ogp.me/ns#">
<head>
<title>めーるてすと</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=2.0">
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="css/add.css">
<script src="https://code.jquery.com/jquery-2.2.4.min.js" integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44=" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://ajaxzip3.github.io/ajaxzip3.js" charset="UTF-8"></script>
<script src="helper/core.js"></script>
</head>
<body>

<div class="container">
	<h1>testメール：入力画面</h1>
	<hr>
	<form action="check.php" method="post">
		<input type="hidden" name="no" value="123">
		<table class="table table-bordered table-condensed">
			<caption><span class="label label-danger">必須</span>は必ず入力してください。</caption>
			<tbody>
				<tr>
					<th>あああ <span class="label label-danger">必須</span></th>
					<td>
						姓<input type="text" name="name1" size="10" value="<?php echo h(@$_POST['name1']?$_POST['name1']:'山田') ?>" data-label="氏名(姓)" data-rule="CONV('KV'),REQ,LEN(1,5)">
						名<input type="text" name="name2" size="10" value="<?php echo h(@$_POST['name2']?$_POST['name2']:'次朗') ?>" data-label="氏名(名)" data-rule="CONV('KV'),REQ,LEN(1,15)">
						<span data-status="name1 name2"></span>
						<span data-error="name1 name2"></span>
					</td>
				</tr>
				<tr>
					<th>メールアドレス <span class="label label-danger">必須</span></th>
					<td>
						<div>
							<input type="text" name="mail" value="<?php echo h(@$_POST['mail']?$_POST['mail']:'test@kazaoki.jp') ?>" data-label="メールアドレス" data-rule="REQ,MAIL">
							<span data-status="mail"></span>
							<span data-error="mail"></span>
						</div>
						<div>
							<input type="text" name="mail2" value="<?php echo h(@$_POST['mail2']?$_POST['mail2']:'test@kazaoki.jp') ?>" data-label="メールアドレス(確認用)" data-rule="REQ,MAIL,SAME('mail', '上欄と同じメールアドレスを入力してください。')">
							<span data-status="mail2"></span>
							<span data-error="mail2"></span>
						</div>
					</td>
				</tr>
				<tr>
					<th>文章 <span class="label label-danger">必須</span></th>
					<td>
						<textarea name="comment" cols="40" rows="5" data-label="ご意見・ご要望" data-rule="REQ,LEN(0,1000)"><?php echo h(@$_POST['comment']?$_POST['comment']:"テストメール\n憂鬱\nソ連\n漢字\n") ?></textarea>
						<span data-status="comment"></span>
						<span data-error="comment"></span>
					</td>
				</tr>
				<tr>
					<th>同意チェック <span class="label label-danger">必須</span></th>
					<td>
						<div><label><input type="checkbox" id="agree" name="agree"> 同意する</label></div>
					</td>
				</tr>
			</tbody>
		</table>
		<input type="submit" class="btn btn-primary" value="確認画面へ &raquo;">
	</form>
</div>

</body>
</html>

