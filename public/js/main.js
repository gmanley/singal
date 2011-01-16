$(function () {
  colorbox_init();

  $('.pagination a').live('click', function () {
    var url = $(this).attr("href").replace(/^.*\/page\//, "#/page/");
    AjaxLinks.setLocation(url);
    return false;
  });

  AjaxLinks.run();
});

var AjaxLinks = $.sammy('#content', function() {

  this.get('#/page/:page_number', function() {
    $("#loading").fadeIn("fast");
    $('#content').load("/page/" + this.params['page_number'] + " #content > *", function () {
      $("#loading").fadeOut("fast");
      colorbox_init();
    });
  });

});

function colorbox_init() {
  $(".thumbnail").colorbox({
    maxWidth: "95%",
    maxHeight: "95%"
  });
}