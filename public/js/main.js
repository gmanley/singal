$('#content').infinitescroll({
  navSelector  : "ul.pager",
  nextSelector : "ul.pager li.next.jump a",
  itemSelector : "#content #thumbnails",
  local      : true
});

Shadowbox.init({
animate: false
});

$(document).ready(function(){  

$('ul.pager:first').hide();

});
