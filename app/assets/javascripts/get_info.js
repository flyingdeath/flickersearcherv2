$(window).load(function(){
    function deleteDomObj(obj){
        var a = [obj]
        delete a[0];
        a = null;
        obj = null;
        return null;
    }
    var ratio, ratio_rev, width, height, rHeight, rWidth ;
    var wHeight  = parseInt(window.innerHeight);
    var wWidth = parseInt(window.innerWidth);
    var img = $("#main_image")[0];

    height = (wHeight - 50);
    width = (wWidth - 300);

    ratio =  img.width / img.height;
    ratio_rev =  img.height / img.width;

    rWidth =  ratio_rev *  height;
    rHeight = ratio *  width;

    if(img.width > img.height){
      if (rHeight > height){
        if(parseInt(ratio_rev * width) <= height){
        	img.height = parseInt(ratio_rev * width) ;
        }else{
        	img.height = height;
        }
      }else{
       img.width = width;

      }
    }else{
      if (rWidth > width){
        img.width = parseInt(ratio * height);
      }else{
        img.height = height;

      }
    }
    img = deleteDomObj(img);
});