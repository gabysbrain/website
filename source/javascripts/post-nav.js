
$(document).ready(function() {
  // dynamically add the magellan stuff to the post
  var pageNav = $('.pagenav dl.sub-nav');
  var test = $('article h2');
  $('article h2').each(function() {
    var h2Id = this.id;
    var h2Name = this.innerText;
    $(this).attr("data-magellan-destination", h2Id);
    $(this).before('<a name="'+h2Id+'"></a>');
    pageNav.append('<dd data-magellan-arrival="'+h2Id+'">' +
                      '<a href="#'+h2Id+'">'+h2Name+'</a>' +
                   '</dd>');
  });
});

