
$(function(){
	$('#user-match-stats').delegate('tr', 'click', function(e){
                window.location=$(this).attr('href');
        });
});