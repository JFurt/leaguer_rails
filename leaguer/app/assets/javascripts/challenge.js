var popup_on;
var ready;
var user_counter=0;

ready = function(){
	$(".challenge_btn").click(preparePopUp);
	$(".select_user").change(updateUserCounter);
	unsetAllSelectedUsers();
}

$(document).ready(ready);

$(document).on('page:load',ready)


function preparePopUp(){
	$("input#challenge_id").attr("value",$(this).attr("id").split('-')[2])
	openPopUp();
}

function openPopUp(){
   popup_on = true;
   $('#popup').fadeIn("slow");
   $("#contentDiv").css({ // this is just for style
       "opacity": "0.3" 
   });
   window.setTimeout(closeBinder,500);      
}

function closePopUp() {    // TO Unload the Popupbox

   popup_on = false;
   $('#popup').fadeOut("slow");
   $("#contentDiv").css({ // this is just for style       
       "opacity": "1" 
   });
   $("#contentDiv").unbind("click");
   	unsetAllSelectedUsers();
}    

function closeBinder(){
   $("#contentDiv").click(function(){closePopUp();});
}

function updateUserCounter(){

    if($(this).is(":checked")) {
    	user_counter++;
    }else{
    	user_counter--;
    }
    if(user_counter==5){
    	$("#submit_challenge_btn").removeAttr("disabled");
    }else{
    	$("#submit_challenge_btn").attr("disabled","disabled")
    }
}
function unsetAllSelectedUsers(){
	$(".select_user").removeAttr('checked');
	user_counter=0;
}