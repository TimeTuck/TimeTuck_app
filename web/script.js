function toggle_visibility(id){
	var e = document.getElementById(id);
	if(e.style.display == 'block')
		e.style.display = 'none';
	else
		e.style.display = 'block';	
}

$(document).ready(function(){
    $("button").click(function(){
        $("#div1").fadeIn();
        $("#mainBox").hide();
        $("#div2").fadeIn("slow");
	    $("#div3").fadeIn(3000);
    });
});

	
