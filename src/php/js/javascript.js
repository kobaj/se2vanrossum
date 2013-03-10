$(document).ready(function(){
	var json = $('#board_json').html();
	var obj = jQuery.parseJSON(json);
	
	var table = '<div>'
	$.each(obj, function(i, item) {
	   
		table += '<div>'
		$.each(item, function(e, row) {
		 
			table += '<span class="border table_letter">' + row + '</span>';
			
		});
		table += '<div>'
		
	});
	table += '</div>'
		
	$('#board_json').html(table);
});