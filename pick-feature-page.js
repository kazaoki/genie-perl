
/**
 * 表示中のページから、feature用の「ページを検証する」を生成するブックマークレット
 */

// コンパイラ
// https://closure-compiler.appspot.com/home
// ↓
// 「javascript:（コンパイルしたコード）」をブックマークしてください。

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

var max=[];max.type=max.value=max.option=0;
var line=[];

// PATH
{
	line.push({
		type:   'PATH',
		value:  window.location.pathname
	});
}

// TITLE
{
	line.push({
		type:  'TITLE',
		value: document.title
	});
}

// WORD: h1
{
	line.push({
		type:   'WORD',
		value:  document.querySelector('h1').innerText.replace(/\n/g, '\\n'),
		option: 'h1'
	});
}

// 整形と出力
for(i in line){
	var element = line[i];
	// type
	if(max.type<cc(element.type)) max.type=cc(element.type);
	// value
	if(max.value<cc(element.value)) max.value=cc(element.value);
	// option
	if(max.option<cc(element.option)) max.option=cc(element.option);
}
out='		* ページを検証する\n';
for(i in line){
	var col=line[i];
	out +=
		(col.dis?'#':'')+'\t\t\t'+
		'| '+col.type   + ss(max.type   - cc(col.type))   + ' ' +
		'| '+col.value  + ss(max.value  - cc(col.value))  + ' ' +
		(col.option ? '| '+col.option + ss(max.option - cc(col.option)) + ' ' : '') +
		'|\n'
	;
}

var box = document.createElement('textarea');
with(box) {
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
