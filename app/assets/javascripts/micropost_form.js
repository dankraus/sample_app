$(function(){
	$('#micropost_content').keyup(micropost_content_KeyUp);
});

//count charecters in content fielld
var micropost_content_KeyUp = function(e){
	var sender = $(e.currentTarget);
	var currentLength = sender.val().length;
	var maxLength = 140;
	
	if(currentLength > maxLength ){
		console.log(currentLength);
		var val = sender.val();
		console.log(val.substr(0, maxLength));
		$('#micropost_content').val(val.substr(0, maxLength));
	}

	$('#micropost_char_counter').html(currentLength + '/' + maxLength);
}