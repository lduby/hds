// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
  var followable_users=new Array(); // regular array (add an optional integer)
  $.getJSON('/profiles/search_followable_users',function(data){
         var i=0;
         for(i=0;i<data.length;i++){
            console.log(data[i]);
            followable_users[i]=data[i];
        }
        $('#followable_user').typeahead({source: followable_users, items:10});
    });
});