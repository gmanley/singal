$(document).ready(function(){

$("a[rel='gallery1']").colorbox({maxWidth:"95%", maxHeight:"95%"});

$("a.gallery['href']").each(function() { 
  this.href = this.href.replace(/(http|https)(:\/\/)(www\,|\w+\.)?(\d|\w+)(:\d+)?(\/bot\?)/, "");
});

});