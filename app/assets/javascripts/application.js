// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require best_in_place
//= require_tree .

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery.fn.displayWithAjax = function(location) {
  this.click(function(event) {
    // Rendre inactive toutes les li
    $('.nav-list li').removeClass("active");
    // Activer la li cliquée
    $(this).closest("li").addClass("active");
    // Afficher sans layout le résultat du href dans la div location
    var href = $(this).attr("href");
    $(location).load(href);
    // Retourne false pour ne pas que le lien soit suivi
    event.preventDefault();
    
    return false;
  })
  return this;
};

function hide_load_and_show_div(divname,url) {
  $(divname).hide();
  $(divname).load(url, function() {
      $(this).show('slow');
  });
}
