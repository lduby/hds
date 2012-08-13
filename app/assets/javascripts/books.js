$(document).ready(function() {
  var st=new Array(); // regular array (add an optional integer)
  $.getJSON('/books/search_publishers',function(data){
         var i=0;
         for(i=0;i<data.length;i++){
            console.log(data[i]);
            st[i]=data[i];
        }
        $('.typeahead').typeahead({source: st, items:5});
    });
});
