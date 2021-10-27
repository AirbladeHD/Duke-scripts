$(function(){
    $('#container').hide();
    window.onload = function(e) {
        window.addEventListener("message", (event) => {
            var item = event.data;
            if(item !== undefined && item.type === "ui") {
                if(item.display === true) {
                    $('#container').show();
                } else {
                    $('#container').hide();
                }
            }
        })
    }
    $("#close").click(function() {
        $.post("http://duke_identity/exit", JSON.stringify({}));
        return
    })
})