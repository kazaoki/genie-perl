var args = [];
for(var i = 0; i < WScript.Arguments.length; i++) args.push(WScript.Arguments.Item(i));
WScript.CreateObject('SAPI.SpVoice').Speak('<volume level="100">'+'<rate speed="2">'+'<pitch middle="0">'+args.join(' ')+'</pitch>'+'</rate>'+'</volume>', 8);
