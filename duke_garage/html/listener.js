var id = "none"

$(function(){
    $('#container').hide();
    window.onload = function(e) {
        window.addEventListener("message", (event) => {
            var item = event.data;
            if(item !== undefined && item.type === "ui") {
                if(item.display === true) {
                    $('#container').show();
                    vehicles = item.vehicles
                    vehicles.forEach(function(e) {
                        $('#vehicles').append("<div class='element' id='" + e['name'] + "'></div>")
                    })
                } else {
                    $('#container').hide();
                }
            }
        })
    $('.element').click(function(){
        id = this.attr('id');
    })
    $('#out').click(function(){
        $.post("http://duke_garage/out", JSON.stringify({
            name: currentVehicle,
            primary: $('#primary').val(),
            secondary: $('#secondary').val(),
            mods: mods_list
        }));
    })
    }
})
