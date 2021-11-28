var currentVehicle = 0

$(function(){
    $('#container').hide();
    window.onload = function(e) {
        window.addEventListener("message", (event) => {
            var item = event.data;
            if(item !== undefined && item.type === "ui") {
                currentVehicle = item.num;
                hp = document.getElementById('hp');
                turbo = document.getElementById('turbo');
                traktion = document.getElementById('traktion');
                handling = document.getElementById('handling');
                hp.style.strokeDashoffset = 314*(1 + (item.hp/1000));
                turbo.style.strokeDashoffset = 314*(1 + (item.turbo/1000));
                traktion.style.strokeDashoffset = 314*(1 + (item.traktion/1000));
                handling.style.strokeDashoffset = 314*(1 + (item.handling/1000));
                $('#vehicle_price').html("Preis: " + item.price + "$");
                if(item.display === true) {
                    $('#container').show();
                } else {
                    $('#container').hide();
                }
            }
            if(item !== undefined && item.type === "update") {
                currentVehicle = item.num;
                hp = document.getElementById('hp');
                turbo = document.getElementById('turbo');
                traktion = document.getElementById('traktion');
                handling = document.getElementById('handling');
                hp.style.strokeDashoffset = 314*(1 + (item.hp/1000));
                turbo.style.strokeDashoffset = 314*(1 + (item.turbo/1000));
                traktion.style.strokeDashoffset = 314*(1 + (item.traktion/1000));
                handling.style.strokeDashoffset = 314*(1 + (item.handling/1000));
                $('#vehicle_price').html("Preis: " + item.price + "$");
                $('#vehicle_name').html(item.name);
            }
        })
    }
    $('#arrow_right').click(function(){
        $.post("http://duke_vehicles/switch", JSON.stringify({
            d: "right",
            c: currentVehicle
        }));
    })
    $('#arrow_left').click(function(){
        $.post("http://duke_vehicles/switch", JSON.stringify({
            d: "left",
            c: currentVehicle
        }));
    })
    $('#abbort').click(function(){
        $.post("http://duke_vehicles/exit", JSON.stringify({}));
        return
    })
})