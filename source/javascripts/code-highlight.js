
$(document).ready(function() {
  $('pre code').each(function() {
    $(this).parent().addClass('prettyprint');
  });
  prettyPrint();
});

