$(document).ready(function(){
	
	/* convert json to board */
	var json = $('#board_json').html();
	
	if(json != undefined && json != '')
	{
		var obj = jQuery.parseJSON(json);
	
		var table = '<div>'
		$.each(obj, function(i, item) {
	   
			table += '<div>'
			$.each(item, function(e, row) {
		 
				table += '<span x="'+ i +'" y="'+ e +'" class="border table_letter">' + row + '</span>';
			
			});
			table += '<div>'
		
		});
		table += '</div>'
		
		$('#board_json').html(table);
	}
	
	/* show or hide output */
	
	$('#output_display').on('click', function(){
		$('#acl2_output').slideToggle();
	});
	
	/* and solve the board */
	
	$('.table_letter').on('click', function(){
		var my_this = $(this);
		
		var x = $(this).attr('x');
		var y = $(this).attr('y');
		var letter = $(this).html();
		
		var solution = $('#board_solution').html();
		
		$.getJSON('wordsearch_play.php', {'action': 'check_letter',
			'letter': letter,
			'x': x,
			'y': y,
			'solution': solution}, function(j) {
			if(j.success)
			{
				if(j.correct)
					my_this.css('background-color', '#33FF33');
				else
					my_this.css('background-color', 'red');
			}
		});	
	});
});