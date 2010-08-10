$('#content').infinitescroll({
  navSelector  : "ul.pager",
  nextSelector : "ul.pager li.next.jump a",
  itemSelector : "#content #thumbnails",
  local      : true
});

$(document).ready(function(){


$("a[rel='gallery1']").live("click", function(){ 
  $(this).colorbox({open:true, maxWidth:"95%", maxHeight:"95%"}); 
  return false;
});

$('ul.pager:first').hide();

});