$(document).ready(function () {

  // Initialize colorbox plugin.
  $(".thumbnail").colorbox({
    maxWidth: "95%",
    maxHeight: "95%"
  });

  function fitImages () {

    // Reset image size
    $("#thumbnails").css({'width': "100%"});

    var colWrap = $("#thumbnails").width();
    // Number of 160px images that can fit per row, rounded down to a whole number.
    var colNum = Math.floor(colWrap / 160);
    // Width of row divided by the ammount of columns it can fit, rounded down to a whole number.
    var colFixed = Math.floor(colWrap / colNum);

    // Set width of row in pixels instead of percent (Fixes cross browser issue).
    $("#thumbnails").css({'width': colWrap});
    // Same as above but for re-adjusted column.
    $(".thumbnail img").css({'width': colFixed});
  }

  // Run on page load...
  fitImages();
  // and whenever the window is resized.
  $(window).resize(function () {
    fitImages();
  });

});