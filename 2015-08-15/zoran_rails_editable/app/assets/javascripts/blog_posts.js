// a BlogPost update via ajax

function updateBlogPost(elem, attr, value) {
  function ajaxURL(elem) {
    return("blog_posts/" + elem.closest('tr').data('id') + ".json");
  }

  function ajaxDone(elem) {
    $("#notice").html("saved").animate({opacity: 0.8}, function() {
      // Animation complete.
      $(this).html("");
    });
    return true;
  }

  var blogPost = {};
  blogPost[attr] = value;

  $.ajax({
    method: 'PATCH',
    url: ajaxURL(elem),
    data: { blog_post: blogPost },
  }).done(ajaxDone);
  return(value);
}

$(function(){
  $('#blog_posts .js-title').editable(function(value, settings) {
    updateBlogPost($(this), "title", value);
    return(value);
  });
});

$(document).on("change", "#blog_posts .js-draft", function(){
  var elem = $(this);
  updateBlogPost(elem, "draft", elem.prop('checked'));
});

