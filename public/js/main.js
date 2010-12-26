$(document).ready(function () {

  colorbox_init();

  $('.pager a').live('click', function () {
    var url = $(this).attr("href");
    var pageNumber = url.replace(/^.*\?page=/, "");
    $.history.load(pageNumber);
    return false;
  });

  $.history.init(function (pageNumber) {
    if (pageNumber !== "") {
      loadPage(pageNumber);
    };
  });

});

function colorbox_init() {
  $(".thumbnail").colorbox({
    maxWidth: "95%",
    maxHeight: "95%"
  });
}

function loadPage(pageNumber) {
  $("#loading").fadeIn("fast");
  $('#content').load("/?page=" + pageNumber + " #content > *", function () {
    $("#loading").fadeOut("fast");
    colorbox_init();
  });
}