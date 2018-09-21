basic usage 

 Rails root / flickr user id get.js
  screen scaping javascirpt, for use with '/mainpage/batch' to supply the user id's 
  run from the web console inside the developer tools of the browser such as firefox 
  run on page 'people you follow'
   https://www.flickr.com/people/<your user name or id >/contacts
 
'/mainpage/search_nature'
    100 images tagged with nature
'/mainpage/interesting'
    100 images per page same category as flickr.com/explore
'/mainpage/save_interesting'
    100 images per page same category as flickr.com/explore, downloads list
'/mainpage/next_page'
    called by interesting , search_nature
'/mainpage/pervous_page'
    called by interesting , search_nature
    
'/mainpage/batch'
    multiple user input page image dowaload 500 at a clip, flickr user ids delimited by newlines
    use Javascirpt code form 'flickr user id get.js'
 '/mainpage/save_users'
    called by batch to download iamges from each user 500 at a clip downloads to Rails root '/cache'
'/mainpage/save_user?id='
     save one users image  500 at a clip downloads to Rails root '/cache'
     
'/mainpage/getinfo/:id'
    gets image meta data and shows a screen size image :id = image id 
'/mainpage/transfrom'
    transfroms 'cache' directory to iamges inside there users directory so for example 'cache/user name/image title _image id.jpg' 
    
(note: image ids are included at the end of the file name after the underscore )
    
