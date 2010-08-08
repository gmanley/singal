$('#content').infinitescroll({
  navSelector  : "ul.pager",
  nextSelector : "ul.pager li.next.jump a",
  itemSelector : "#content #thumbnails",
  local      : true
});

$(document).ready(function(){  
  $("#content").find("a.fancybox").fancybox({
    'padding': 10,
    'transitionIn'  : 'elastic',
    'transitionOut' : 'elastic',
    'speedIn'   : 600, 
    'speedOut'    : 200,
    'titleShow'   : false
  });

$('ul.pager:first').hide();

});
