$(document).ready(function() {
  var pub=new Array(); // regular array (add an optional integer)
  $.getJSON('/books/search_publishers',function(data){
         var i=0;
         for(i=0;i<data.length;i++){
            console.log(data[i]);
            pub[i]=data[i];
        }
        $('#book_publisher').typeahead({source: pub, items:5});
    });
  var aut=new Array(); // regular array (add an optional integer)
  $.getJSON('/books/search_authors',function(data){
         var i=0;
         for(i=0;i<data.length;i++){
            console.log(data[i]);
            aut[i]=data[i];
        }
        $('#book_authors').typeahead({source: aut, mode: 'multiple', items:5});
    });
});
