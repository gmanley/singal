$('#content').infinitescroll({
  navSelector  : "ul.pager",
  nextSelector : "ul.pager li.next.jump a",
  itemSelector : "#content #thumbnails",
  local      : true
});

$(document).ready(function(){

$('ul.pager:first').hide();

});
