var up = false;
var appOpened = false;

function toggle() {
    if (up) {
        $('#phone').css("top", "100%");
        up = false;
    } else {
        $('#phone').css("top", "calc(95% - 20vw * 1.78)");
        up = true;
    };
}


$(function() {
    //$('#phone').hide();
    window.onload = function(e) {
        $.post("http://Phone/phoneStarted", JSON.stringify({}));
        window.addEventListener("message", (event) => {
            var item = event.data;
            if (item !== undefined && item.type === "ui") {
                $('#phone').show();
                toggle();

            }

            if (item !== undefined && item.type === "addapp") {
                $("#appList").append('<li><img id="' + item.id + '" src="' + item.url + '"></li>');
                $("#" + item.id).on('click', function(event) {
                    appOpened = true;
                    $.post("http://Phone/openApp", JSON.stringify({
                        sender: item.id
                    }));
                });
            }
            if (item !== undefined && item.type === "js") {
                eval(item.code);
            }

            if (item !== undefined && item.type === "swap") {
                
                $('#screen').html(item.code);
            }

            if (item !== undefined && item.type === "removeApp") {
                $('#' + item.id).parent().remove();
            }
        })


    }


});

$(document).keypress(function(e) {
    var checkEnter = (e.which == 13);
    if (checkEnter) {
        e.preventDefault();
        closePhone();
    }
    return;
});

function closePhone() {
    toggle();
    $.post("http://Phone/closePhone", JSON.stringify({}));
}


function phoneBack() {

    if (appOpened) {
        appOpened = false;
        $('#screen').empty();
        $('#screen').off();
        $('#screen').html("<ul id=\"appList\" class=\"thumbnails\"></ul>")
        $.post("http://Phone/phoneStarted", JSON.stringify({}));
    }
}

$('html').keyup(function(e) {
    if (e.keyCode == 8) {
        phoneBack();
        return false;
    }
    return;
})