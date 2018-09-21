var list = document.getElementsByTagName('span')
var ret ="\n";
var retlist = [];
for(var i = 0 ;i< list.length; i++){
  if(list[i].className =="contact-list-edit"){
   ret += String(list[i].childNodes[1].onclick).replace("function onclick(event) {\nicon_windowOpenFromLink('","").
                                                replace("'); return false;\n}","") +"\n";
  }
}
ret