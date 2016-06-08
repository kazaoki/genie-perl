
$(function(){

	// data-ruleをもつ要素にユニークIDをつける
	// ---------------------------------------
	oid_count = 1000;
	$('[data-rule]').each(function(){
		$(this).attr('data-oid', oid_count++);
		// ついでにblurカウントメソッド追加
		$(this).data('blurcount', 0);
		$(this).on('blur', function(){
			$(this).data('blurcount', $(this).data('blurcount')+1);
		});
	});

 	// 入力要素ごとにバリデーションを実行
 	// ----------------------------------
 	// Deferred使用
	validElements = function(){
		var mode = '';
		var target = this;
		var funcs = [];

		// フォームSUBMITの場合はそのフォーム中の全ての要素に対して：SUBMITモード
		if(this.tagName == 'FORM') {
			mode = 'SUBMIT';
			$(this).find('[data-rule]').each(function(){
				$(this).blur();
				$(this).clearError();
				funcs.push( $(this).makeRuleFuncs()() );
			});
		}
		// 要素の場合はその要素に対してのみ：SINGLEモード
		else {
			mode = 'SINGLE';
			$(this).clearError();
			funcs.push( $(this).makeRuleFuncs()() );
		}

		// 登録された関数全てでエラーが出てないかチェック
		$.when.apply($, funcs)
			.done(function(){
				if(mode == 'SUBMIT') {
					$(target).off('submit.validate');
					$(window).off('beforeunload');
					$(target).submit();
				}
			})
			.fail(function(){
				if(mode == 'SUBMIT') {
					// failの場合は途中でも抜けてしまうため、ここで全て完了するまで待つ。
					var tm = setInterval(function(){
						complete=0;
						for(i=0; i<funcs.length; i++){
							if(funcs[i].state()!='pending') complete++;
						}
 						if(funcs.length==complete){
							clearInterval( tm );
							var outer = $('body').scrollTop()>0 ? 'body' : 'html';
							targetPos = $('.error[data-rule]:first').parent().offset().top;
							$(outer).animate({scrollTop:targetPos}, 500, function(){
								// チェック項目が2つ以上（個人情報入力画面）のときはアラート出す
								if(funcs.length>=2) alert('入力値に間違いがありますのでご確認下さい。');
							});
						}
					}, 100);
				}
			})
		;

		return false; // 標準のSUBMITは無効
	};
	$('form [data-rule]').on('blur', validElements);
	$('form').on('submit.validate', validElements);

	// URLに「check_on_load」が含まれている場合、画面ロード時に入力チェックを実行する
	if(-1!=$.inArray('check_on_load', window.location.href.split(/\W/))){
		$(this).find('[data-rule]').each(function(){
			$(this).blur();
		});
	}
	
});

/**
 * ajaxValid()
 */
$.fn.ajaxValid = function(type, message, defer){
	$.ajax({
		method:   'POST',
		url:      '/mail/helper/ajax-valid.php',
		data:     { rule: type, data: $(this).val() },
		cache:    false,
		dataType: 'text',
		context:  $(this),
		// async:    false
	}).done(function(result) {
		if(result){
			defer.resolve();
		} else {
			$(this).setError(message);
			defer.reject();
		}
	}).fail(function(result){
		alert('通信エラーが発生しました。しばらくおいてから再度送信を行って下さい。')
		defer.reject();
	});
};

/**
 * setError()
 */
$.fn.setError = function( message ){
	$(this).data('error-message', message);
};

/**
 * clearError()
 */
$.fn.clearError = function(){
	$(this).data('error-message', '');
}

/**
 * 'data-rule'属性からdeferredな関数を作成して返す
 */
$.fn.makeRuleFuncs = function(){
	selector = '[data-oid='+this.data('oid')+']';
	func_str = 'defer';
	$(ruleStringToFuncs($(this).data('rule'))).each(function(){
		func_str = func_str + ".then(function(){return $('"+selector+"')."+this.toString()+'})';
	});
	func_str += ".always(function(){return $('"+selector+"')."+'updateError()})';
	func_str += ".always(function(){return $('"+selector+"')."+'updateStatus()})';
	return function(){
		var defer = $.Deferred().resolve();
		return eval(func_str);
	};
};
function ruleStringToFuncs(string) {
	var set     = [];
	var pointer = 0;
	var level   = 0;
	var inquote = false;
	for(var i=0; i<string.length; i++){
		char = string[i];
		if(char=='\\' ){ i++; continue; }
		if(char=='"' || char=="'") inquote = inquote ? false : true;
		if(inquote) continue;
		if(char=='(') level++;
		if(char==')') {
			if(level==1){
				set.push(string.substr(pointer, i-pointer+1));
				pointer = i+1;
			}
			level--;
		}
		if(level==0 && char.match(/,/)){
			if(pointer!=i){
				set.push( string.substr(pointer, i-pointer).replace(/([^\)])$/, '$1()') );
			}
			pointer = i+1;
		}
	}
	if(pointer!=i){
		set.push( string.substr(pointer, i-pointer+1).replace(/([^\)])$/, '$1()') );
	}
	return set;
}

/**
 * エラーメッセージの表示を更新する
 */
$.fn.updateError = function(){

	// エラーメッセージ更新用内部関数
	var update_func = function(targets){
		message = '';
		$(targets).each(function(){
			obj = $('[name='+this.toString()+']');
			if(obj.data('blurcount')){
				if(obj.data('error-message')) {
					// error set
					message += '<p class="error-message">'+obj.data('error-message')+'</p>';
					$(obj).addClass('error');
					$(obj).removeClass('success');
				} else {
					// success set
					$(obj).removeClass('error');
					if($(obj).is_default_noreq()) {
						$(obj).removeClass('success');
					} else {
						$(obj).addClass('success');
					}
				}
			}
		});
		return message;
	};

	// <span data-error="～"></span> でエラー定義されている場合
	if($('[data-error~="'+this.attr('name')+'"]').length) {
		$('[data-error~="'+this.attr('name')+'"]').each(function(){
			$(this).html(update_func($(this).data('error').split(' ')));
		});
	}
	// <span data-error="～"></span> を書いていない場合（でもチェックはする）
	else {
		update_func([this.attr('name')]);
	}

};

/**
 * 入力ステータス（OK|NG）の表示を更新する
 */
$.fn.updateStatus = function(){
	$('[data-status~="'+this.attr('name')+'"]').each(function(){
		var element = this;
		targets = $(element).data('status').split(' ');
		blurcount_num = 0;
		$(targets).each(function(){
			if($('[name='+this.toString()+']').data('blurcount')) blurcount_num++; // 要素内でblurした数をカウントし、グルーピングした要素内で一通りフォーカスが移り終わってから更新対象とするため
		});
		if(targets.length!=blurcount_num){ return; }
		targets = $(this).data('status').split(' ');
		ng_count = 0;
		$(targets).each(function(){
			name = this.toString()
			if($('[name='+name+']').hasClass('error')) ng_count ++;
		});
		$(element)
			.addClass('status')
			.removeClass('ok')
			.removeClass('ng')
		;
		if(ng_count){
			$(element).addClass('ng')
		} else {
			if(!$(obj).is_default_noreq()){
				$(element).addClass('ok')
			}
		}
	});
};

/**
 * 必須項目かどうかチェック（data-ruleにREQがあるか否か）
 */
$.fn.is_required = function(){
	matched = false;
	$(ruleStringToFuncs(this.data('rule'))).each(function(){
		if(this.toString().match(/^REQ\(.*\)$/)) matched = true;
	});
	return matched;
};

/**
 * 必須ではなく、値が初期値の場合にtrueを返す
 */
$.fn.is_default_noreq = function(){
	default_value = $(this).attr('defaultValue');
	if(typeof(default_value) == "undefined") default_value = '';
	return (default_value == $(this).val() && (!$(this).is_required()));
}

/**
 * 文字の幅数を返す（全角=2、半角=1）
 * ---
 * 参考：http://kihon-no-ki.com/javascript-count-multi-byte-characters-as-two-single-byte-one
 */
String.prototype.strwidth = function(){
	str = this.toString();
	len = 0;
	str = escape(str);
	for (i=0; i<str.length; i++, len++) {
		if (str.charAt(i) == '%') {
			if (str.charAt(++i) == 'u') {
				i += 3;
				len++;
			}
			i++;
		}
	}
	return len;
};

// =================================================================================================
// 標準データルール関数
// =================================================================================================

// 必須項目
// --------
$.fn.REQ = function(message){
	var defer = new $.Deferred;
	if($(this).val()=='') {
		$(this).setError(
			message
				? message
				: ($(this).data('label') ? $(this).data('label')+'を' : '')+'入力して下さい。'
		);
		defer.reject();
	} else {
		defer.resolve();
	}
	return defer;
}

// 変換関数
// --------
// 指定できる引数はPHPの mb_convert_kana() の引数と同じです。
// 参考：http://php.net/manual/ja/function.mb-convert-kana.php
$.fn.CONV = function(option){
	return $.ajax({
		method:   'POST',
		url:      '/mail/helper/ajax-conv.php',
		data:     { string: $(this).val(), option: option },
		cache:    false,
		dataType: 'text',
		context:  $(this),
		// async:    false // 非同期にしないと変換前のデータで次の処理に移ってしまう。→defer.then()での処理にしたため、非同期でも問題なく。
	}).done(function(conved, result) {
		if(result=='success') $(this).val(conved);
	}).fail(function(result){
		alert('通信エラーが発生しました。しばらくおいてから再度送信を行って下さい。')
	});
};

// 長さ制限
// --------
$.fn.LEN = function(min_length, max_length){
	var defer = new $.Deferred;
	if($(this).val().strwidth()>=(min_length*2) && $(this).val().strwidth()<=(max_length*2)) {
		defer.resolve();
	} else {
		message = '';
		if(min_length==0) {
			message =
				($(this).data('label') ? $(this).data('label')+'は' : '')+
				max_length+'文字以内で入力して下さい。'
			;
		} else {
			message =
				($(this).data('label') ? $(this).data('label')+'は' : '')+
				min_length+'～'+max_length+'文字で入力して下さい。'
			;
		}
		$(this).setError(message);
		defer.reject();
	}
	return defer;
};

// 正規表現でチェック
// ------------------
$.fn.REG = function(regex){
	var defer = new $.Deferred;
	if($(this).val().match(regex)){
		defer.resolve();
	} else {
		$(this).setError(
			($(this).data('label') ? $(this).data('label')+'が' : '')+
			'正しくありません。'
		);
		defer.reject();
	}
	return defer;
}

// 郵便番号から住所変換
// --------------------
// AjaxZip3使用
// 公式：https://github.com/ajaxzip3/ajaxzip3.github.io
// 著作：https://github.com/ajaxzip3/ajaxzip3.github.io/blob/master/LICENSE
$.fn.ADDR = function(){
	// -------------------------------
	// ex) data-rule="ADDR('address')"
	// -------------------------------
	var defer = new $.Deferred;
	args = arguments;
	if(args.length==1) {
		AjaxZip3.zip2addr(this.get(0), '', args[0], args[0]);
	} else if(args.length==2) {
		AjaxZip3.zip2addr(this.get(0), '', args[0], args[1]);
	} else if(args.length==3) {
		AjaxZip3.zip2addr(this.get(0), '', args[0], args[1], args[2]);
	} else if(args.length==4) {
		AjaxZip3.zip2addr(this.get(0), '', args[0], args[1], args[2], args[3]);
	} else if(args.length==5) {
		AjaxZip3.zip2addr(this.get(0), '', args[0], args[1], args[2], args[3], args[4]);
	}
	defer.resolve();
	return defer;
}
$.fn.ADDRFULL = function(){
	// -------------------------------------------------
	// ex) data-rule="ADDRFULL('zip1','zip2','address')"
	// -------------------------------------------------
	var defer = new $.Deferred;
	args = arguments;
	if(args.length==3) {
		AjaxZip3.zip2addr(args[0], args[1], args[2], args[2]);
	} else if(args.length==4) {
		AjaxZip3.zip2addr(args[0], args[1], args[2], args[3]);
	} else if(args.length==5) {
		AjaxZip3.zip2addr(args[0], args[1], args[2], args[3], args[4]);
	} else if(args.length==6) {
		AjaxZip3.zip2addr(args[0], args[1], args[2], args[3], args[4], args[5]);
	} else if(args.length==7) {
		AjaxZip3.zip2addr(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
	}
	defer.resolve();
	return defer;
}

// メールアドレスチェック
// ----------------------
$.fn.MAIL = function(){
	var defer = new $.Deferred;
	$(this).CONV('a');
	$(this).ajaxValid('EMAIL', '正しいメールアドレスではありません。', defer);
	return defer;
}

// 同値チェック
// ------------
$.fn.SAME = function(name, error_message){
	var defer = new $.Deferred;
	if($(this).val() == $('input[name='+name+']').val()) {
		defer.resolve();
	} else {
		$(this).setError(error_message);
		defer.reject();
	}
	return defer;
}

// =================================================================================================
// カスタムデータルール関数
// =================================================================================================

// 楽天ポイント口座番号
// --------------------
$.fn._ACCOUNT = function(){
	var defer = new $.Deferred;
	if($(this).val()) {
		$(this).ajaxValid('ACCOUNT', '正しい楽天ポイント口座番号ではありません。ご確認の上お問い合せください。', defer);
	} else {
		$(this).setError('楽天ポイント口座番号が指定されていません。');
	}
	return defer;
}

// JIS安全文字チェック
// -------------------
$.fn._JISSAFE = function(){
	var defer = new $.Deferred;
	if($(this).val()) {
		var prefix = $(this).data('label') ? $(this).data('label')+'は' : '';
		$(this).ajaxValid('JISSAFE', prefix+'許可されている文字のみでご入力下さい。', defer);
	}
	return defer;
}

// 電話番号
// --------
// ハイフンを除いたデータが12桁以内という制限が必要なため、追加でカスタム定義
$.fn._TEL = function(){
	var defer = new $.Deferred;
	telnum = $(this).val().replace(/\D/g, '');
	if($(this).val()){
		if(telnum.length > 12) {
			defer.reject();
			$(this).setError('電話番号が正しくありません。');
		} else {
			defer.resolve();
		}
	}
	return defer;
}
