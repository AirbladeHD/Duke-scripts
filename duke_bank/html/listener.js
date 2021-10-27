$(function(){
    window.onload = function(e) {
        $('#container').hide();
        window.addEventListener("message", (event) => {
            var item = event.data;
            if(item !== undefined && item.type === "ui") {
                if(item.display === true) {
                    $('#container').show();
                    $('#balance').html("Kontostand: " + item.balance + "$");
                    $("#out").val('')
                    $("#in").val('')
                } else {
                    $('#container').hide();
                }
            }
        })
    }
    $("#close").click(function() {
        $.post("http://bank/exit", JSON.stringify({}));
        return
    })
    $("#out_confirm").click(function() {
        let inputValue = $("#out").val()
        if(inputValue.length == 0) {
            $.post("http://bank/error", JSON.stringify({
                error: "Das Eingabefeld darf nicht leer sein!"
            }));
            return
        } else if($.isNumeric(inputValue) == false) {
            $.post("http://bank/error", JSON.stringify({
                error: "Der Betrag muss eine Zahl sein!"
            }));
            return
        } else if(inputValue <= 0) {
            $.post("http://bank/error", JSON.stringify({
                error: "Der Betrag muss größer als 0 sein!"
            }));
            return
        }
        else {
            $.post("http://bank/out", JSON.stringify({
                amount: inputValue,
            }));
            return
        }
    })
    $("#in_confirm").click(function() {
        let inputValue = $("#in").val()
        if(inputValue.length == 0) {
            $.post("http://bank/error", JSON.stringify({
                error: "Das Eingabefeld darf nicht leer sein!"
            }));
            return
        } else if($.isNumeric(inputValue) == false) {
            $.post("http://bank/error", JSON.stringify({
                error: "Der Betrag muss eine Zahl sein!"
            }));
            return
        } else if(inputValue <= 0) {
            $.post("http://bank/error", JSON.stringify({
                error: "Der Betrag muss größer als 0 sein!"
            }));
            return
        }
        else {
            $.post("http://bank/in", JSON.stringify({
                amount: inputValue,
            }));
            return
        }
    })
})