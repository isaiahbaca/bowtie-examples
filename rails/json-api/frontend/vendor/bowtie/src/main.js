var page = window.page = {
  url             : null,
  template        : null,
  renderTarget    : null,
  data            : null,
  previewScrollX  : null,
  previewScrollY  : null,
  render          : function(data, reload){
    page.data = data || {};
    var target = $(document.createElement("div"));
    $(target).html(page.template(data))
    page.renderTarget.replaceWith(target);
    page.renderTarget = target;

    if(reload === undefined || reload){
      $(document).trigger('turbo:ready')
    }
  }
};

$(document).on('page:fetch', function(event){
  page.url = event.originalEvent.data.url;
});

$(function(){
  var templateElement = $("script#main[type='text/handlebars']");

  if(templateElement.length > 0){
    page.renderTarget = templateElement;
    page.template = Handlebars.compile(templateElement.html());
    page.render(page.data, false);

    if(page.previewScrollX !== null && page.previewScrollY !== null){
      window.scrollTo(page.previewScrollX, page.previewScrollY);
    }
  }
});

Turbolinks.enableTransitionCache();
Turbolinks.enableProgressBar();

window.addEventListener("data", function(event){
  // From https://developer.mozilla.org/en-US/docs/Web/API/window.scrollX
  var target = document.documentElement || document.body.parentNode || document.body;
  page.previewScrollX = (window.pageXOffset !== undefined) ? window.pageXOffset : (target).scrollLeft;
  page.previewScrollY = (window.pageYOffset !== undefined) ? window.pageYOffset : (target).scrollTop;
  page.render(event.detail);
});
