
/**
 * 表示中のページから、feature用の「フォームを検証する」を生成するブックマークレット
 */

// コンパイラ
// https://closure-compiler.appspot.com/home
// ↓
// 「javascript:（コンパイルしたコード）」をブックマークしてください。

// 既存の入力欄を消す
box_id = 'genie-pick-features-box';
if(document.getElementById(box_id)){
	document.getElementById(box_id).blur();
}

// 除外name
var excludes = [
	'csrf_token'
];

/**
 * 全角を2、半角を1で計算した長さを返す関数
 * ----------------------------------------
 */
var cc=function(str) {
	len=0;
	str=escape(str);
	for (i=0;i<str.length;i++,len++) {
		if (str.charAt(i) == "%") {
			if (str.charAt(++i) == "u") {
				i += 3;
				len++;
			}
			i++;
		}
	}
	return len;
}

/**
 * 指定数の長さの空白を返す関数
 * ----------------------------
 */
var ss=function(time){
	var ss='';
	for(i=0; i<time; i++) {
		ss+=' ';
	}
	return ss;
}

var max=[];max.type=max.name=max.value=0;
var line=[];
document.querySelectorAll('input,textarea,select').forEach(function(element){
	var col=[];
	if(element.name && excludes.some(function(str){return str!==element.name})){
		// type
		if(element.tagName==='INPUT') {
			if(element.type==='radio') {
				col.type='RADIO';
				if(!element.checked) col.dis=true;
			} else if(element.type==='checkbox') {
				col.type='CHECK';
				if(!element.checked) col.dis=true;
			} else if(element.type==='hidden') {
				col.type='HIDDEN';
			} else {
				col.type='TEXTBOX';
				if(!element.value.length) col.dis=true;
			}
		} else {
			col.type=element.tagName;
			if(!element.value.length) col.dis=true;
		}
		if(max.type<cc(element.type)) max.type=cc(element.type);
		// name
		col.name=element.name;
		if(max.name<cc(element.name)) max.name=cc(element.name);
		// value
		col.value=element.value.replace(/\n/g, '\\n');
		if(max.value<cc(element.value)) max.value=cc(element.value);
		line.push(col);
	}
});
// 整形と出力
out='		* フォームを検証する\n';
for(i in line){
	var col=line[i];
	out +=
		(col.dis?'#':'')+'\t\t\t'+
		'| '+col.type  + ss(max.type  - cc(col.type))  + ' ' +
		'| '+col.name  + ss(max.name  - cc(col.name))  + ' ' +
		'| '+col.value + ss(max.value - cc(col.value)) + ' |\n'
	;
}

var box = document.createElement('textarea');
with(box) {
	id               = box_id;
	textContent      = out;
	style.position   = 'absolute';
	style.width      = '700px';
	style.height     = '300px';
	style.left       = '50%';
	style.top        = '20px';
	style.marginLeft = '-350px';
	style.padding    = '10px';
	style.zIndex     = 10;
	style.fontFamily = 'monospace';
	style.fontSize   = '10pt';
	onblur           = function(){if(box)parentNode.removeChild(box)};
	onkeydown        = function(e){if(e.keyCode==27){ onblur={}; parentNode.removeChild(box)}};
}
document.body.appendChild(box); 
box.focus();
