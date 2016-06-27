
/**
 * 表示中のフォームから、feature用のテーブルを生成するブックマークレット。
 */

// コンパイラ
// https://closure-compiler.appspot.com/home

// var charcount=function(str) {
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
// var spaces=function(time){
var ss=function(time){
	var ss='';
	for(i=0; i<time; i++) {
		ss+=' ';
	}
	return ss;
}
var maxes=[];maxes['type']=maxes['name']=maxes['value']=0;
var line=[];
$('input,textarea,select').each(function(){
	var column=[];
	var type='';
	if($(this).get(0).tagName==='INPUT') {
		if($(this).attr('type')==='radio') {
			if($(this).prop('checked')) type='RADIO';
		} else if($(this).attr('type')==='checkbox') {
			if($(this).prop('checked')) type='CHECK';
		} else {
			if($(this).val().length) type='TEXTBOX';
		}
	} else {
		if($(this).val().length) type=$(this).get(0).tagName;
	}
	if(type) {
		// type
		column['type']=type;
		if(maxes['type']<type.length) maxes['type']=type.length;
		// name
		column['name']=$(this).attr('name');
		if(maxes['name']<$(this).attr('name').length) maxes['name']=$(this).attr('name').length;
		// value
		column['value']=$(this).val().replace(/\n/g, '\\n');
		if(maxes['value']<$(this).val().length) maxes['value']=$(this).val().length;
		line.push(column);
	}
});
out='';
for(i in line){
	var column=line[i];
	out +=
		'| '+column['type']  + ss(maxes['type']  - cc(column['type']))  + ' ' +
		'| '+column['name']  + ss(maxes['name']  - cc(column['name']))  + ' ' +
		'| '+column['value'] + ss(maxes['value'] - cc(column['value'])) + ' |\n'
	;
}
console.log(out);
// alert(out);
