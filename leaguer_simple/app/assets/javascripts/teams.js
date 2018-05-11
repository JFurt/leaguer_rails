$(document).ready( function(){
	$(".challenge-team").click(function(){
		alert(this.id.split('-')[2]+this.id.split('-')[3]);
		//send_challenge(this.id.split('-')[2])
		//send_challenge()
	});
});

function send_challenge(dest,src){
	//$.ajax({});
	


}