var list = document.getElementsByTagName('td')
var ret ="";
var retlist = [];
for(var i = 0 ;i< list.length; i++){
  if(list[i].className =="contact-list-name"){
  ret += list[i].childNodes[1].innerHTML +"\n";
  retlist = retlist.concat([list[i].childNodes[1]]);
  }
}
ret
//retlist