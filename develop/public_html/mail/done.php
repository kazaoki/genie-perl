<?php
include 'helper/core.php';
if($_SERVER["REQUEST_METHOD"] == "POST"){
	submit();
	header('Location: '.$_SERVER['PHP_SELF']);
	exit;
}
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
	<h1>testメール：完了画面</h1>
	<hr>
	<p>メールが送信完了しました。</p>
	<p><a href="../">メニューに戻る</a></p>
</div>

</body>
</html>
