$(function(){
    $('#container').hide();
    $('#confirm').hide();
    $('#gender').hide();
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
            if(item !== undefined && item.type === "confirm") {
                if(item.display === true) {
                    $('#confirm').show();
                } else {
                    $('#confirm').hide();
                }
            }
            if(item !== undefined && item.type === "gender") {
                if(item.display === true) {
                    $('#gender').show();
                } else {
                    $('#gender').hide();
                }
            }
        })
    }
    $("#close").click(function() {
        $.post("http://duke_identity/exit", JSON.stringify({}));
        return
    })
    $("#yes").click(function() {
        $.post("http://duke_identity/yes", JSON.stringify({}));
        return
    })
    $("#no").click(function() {
        $.post("http://duke_identity/no", JSON.stringify({}));
        return
    })
    $("#male").click(function() {
        $.post("http://duke_identity/male", JSON.stringify({}));
        return
    })
    $("#female").click(function() {
        $.post("http://duke_identity/female", JSON.stringify({}));
        return
    })
})