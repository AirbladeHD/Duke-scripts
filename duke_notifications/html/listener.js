var shift

function sleep(milliseconds) {
    return new Promise(resolve => setTimeout(resolve, milliseconds));
}

$(function(){
    window.onload = function(e) {
        $('#alert').hide();
        window.addEventListener("message", async (event) => {
            var item = event.data;
            if(item !== undefined && item.type === "ui") {
                if(item.display === true) {
                    $('#alert').show();
                    $('#msg').html(item.msg);
                    shift = 110;
                    while(shift > 0) {
                        $('#alert').css("transform", "translateX(" + shift + "%)");
                        shift -= 1;
                        await sleep(1);
                    }
                    await sleep(item.duration);
                    while (shift < 110) {
                        $('#alert').css("transform", "translateX(" + shift + "%)");
                        shift += 1;
                        await sleep(1);
                    }
                    $.post("http://duke_notifications/ResetDisplay", JSON.stringify({}));
                    $('#msg').html("");
                } else {
                    $('#alert').hide();
                }
            }
            if (item !== undefined && item.type === "clear") {
                shift = 0
                while (shift < 110) {
                    $('#alert').css("transform", "translateX(" + shift + "%)");
                    shift += 1;
                    await sleep(1);
                }
                $.post("http://duke_notifications/ResetDisplay", JSON.stringify({}));
                $('#msg').html("");
            }
        })
    }
})