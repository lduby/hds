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
  $('#book_publisher').change( function() {
    var coll = new Array();
    var publisher_name = $('#book_publisher').val();
    if (publisher_name != '') {
      alert("Publisher has changed");
      var autocomplete = $('#book_collection').typeahead();
      $.getJSON('/publishers/collections_by_publisher/'+publisher_name,function(data){
           var i=0;
           for(i=0;i<data.length;i++){
              console.log(data[i]);
              coll[i]=data[i][0];
          }
          autocomplete.data('typeahead').source = coll;
          // $('#book_collection').typeahead({
          //   source: coll
          // });
      });
    }
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
  var illus=new Array(); // regular array (add an optional integer)
  $.getJSON('/books/search_illustrators',function(data){
         var i=0;
         for(i=0;i<data.length;i++){
            console.log(data[i]);
            illus[i]=data[i];
        }
        $('#book_illustrators').typeahead({source: illus, mode: 'multiple', items:5});
    });
  var thm=new Array(); // regular array (add an optional integer)
  $.getJSON('/books/search_themes',function(data){
         var i=0;
         for(i=0;i<data.length;i++){
            console.log(data[i]);
            thm[i]=data[i];
        }
        $('#book_themes').typeahead({source: thm, mode: 'multiple', items:5});
    });
  
});
