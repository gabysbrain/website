
$(document).ready(function() {
  $('pre code').each(function() {
    $(this).parent().addClass('prettyprint');
    if($(this).hasClass('linenums')) {
      $(this).parent().addClass('linenums');
    }
  });
  prettyPrint();
});

