$('#content').infinitescroll({
  navSelector  : "ul.pager",
  nextSelector : "ul.pager li.next.jump a",
  itemSelector : "#content #thumbnails",
  local      : true
});

$(document).ready(function(){

$("a[rel='gallery1']").colorbox();
$('ul.pager:first').hide();

});
