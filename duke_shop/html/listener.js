var total = 0;
$(function(){
    window.onload = function(e) {
        $('#container').hide();
        window.addEventListener("message", (event) => {
            var item = event.data;
            if(item !== undefined && item.type === "ui") {
                if(item.display === true) {
                    total = 0;
                    $('#container').show();
                    $('#subtotal').html("Gesamtpreis: " + total + "$");
                    $('#cart_medkit').remove();
                    $('#cart_repairkit').remove();
                } else {
                    $('#container').hide();
                }
            }
        })
    }
    $("#close").click(function() {
        $.post("http://shop/exit", JSON.stringify({}));
        return
    })
    $("#buy").click(function() {
        var medkit_cart = $('#cart').find("#cart_medkit").text();
        var medkit_in_cart = medkit_cart.substr(8);
        if (medkit_cart.length == 0) {
          medkit_in_cart = 0
        } else if (medkit_in_cart.length == 0) {
          medkit_in_cart = 1
        }
        var repairkit_cart = $('#cart').find("#cart_repairkit").text();
        var repairkit_in_cart = repairkit_cart.substr(14);
        if (repairkit_cart.length == 0) {
          repairkit_in_cart = 0
        } else if (repairkit_cart.length == 0) {
          repairkit_in_cart = 1
        }
        $.post("http://shop/buy", JSON.stringify({
          medkits: medkit_in_cart,
          repairkits: repairkit_in_cart,
        }));
        return
    })
    $("#buy_medkit").click(function() {
      var tabledata = $('#cart').find("#cart_medkit").html();
      if (tabledata == null) {
        $('#cart').append("<tr><td id='cart_medkit'>Medkit</td></tr>");
      } else {
        var cart = $('#cart').find("#cart_medkit").text();
        var in_cart = cart.substr(8);
        if (in_cart.length == 0) {
          $('#cart').find("#cart_medkit").html("Medkit x2");
        } else {
          var to_add = parseInt(in_cart) + 1;
          $('#cart').find("#cart_medkit").html("Medkit x" + to_add);
        }
      }
      total += 400;
      $('#subtotal').html("Gesamtpreis: " + total + "$");
    })
    $("#buy_repairkit").click(function() {
      var tabledata = $('#cart').find("#cart_repairkit").html();
      if (tabledata == null) {
        $('#cart').append("<tr><td id='cart_repairkit'>Reperaturkit</td></tr>")
      } else {
        var cart = $('#cart').find("#cart_repairkit").text()
        var in_cart = cart.substr(14)
        if (in_cart.length == 0) {
          $('#cart').find("#cart_repairkit").html("Reperaturkit x2")
        } else {
          var to_add = parseInt(in_cart) + 1
          $('#cart').find("#cart_repairkit").html("Reperaturkit x" + to_add)
        }
      }
      total += 1000;
      $('#subtotal').html("Gesamtpreis: " + total + "$");
    })
})
