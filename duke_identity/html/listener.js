var fonts = ["Dancing Script", "Amatic SC", "Homemade Apple", "Indie Flower", "Nothing You Could Do", "Ole", "Parisienne", "Reenie Beanie", "Rock Salt", "Sacramento"]
var font
var signed = false;
var previousHabits = [];

function error(msg) {
    $.post("http://duke_identity/error", JSON.stringify({
        error: msg
    }));
}

function SubmitDataToServer(firstName, lastName, gender, family, size, eyeColor, dob, job, font) {
    $.post("http://duke_identity/submit", JSON.stringify({
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        family: family,
        size: size,
        eyeColor: eyeColor,
        dob: dob,
        formerJob: job,
        font: font,
        previousHabits: previousHabits
    }));
}

$(function(){
    $('#container').hide();
    $('#confirm').hide();
    $('#gender').hide();
    $('#signatureConfirm').hide();
    $('#identityConfirm').hide();
    $('#close').hide();
    window.onload = function(e) {
        window.addEventListener("message", (event) => {
            var item = event.data;
            if(item !== undefined && item.type === "document") {
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
            if (item !== undefined && item.type === "office") {
                $('#identityConfirm').show();
            }
        })
    }
    $("#signYes").click(function () {
        var firstName = $('#firstname').val();
        var lastName = $('#lastname').val();
        var gender = $("input[name='gender']:checked").val();
        var family = $("input[name='family']:checked").val();
        var size = $('#size').val();
        var eyeColor = $('#eyes').val();
        var dob = $('#dob').val();
        var official = $('#official').val();
        var selfEmployed = $('#self-employed').val();
        var employee = $('#employee').val();
        var volunteer = $('#volunteer').val();
        var other = $('#other').val();
        var job = ""
        var jobs = [official, selfEmployed, employee, volunteer, other]
        if ($('#from1').val() != "" && $('#till1').val() != "" && $('#in1').val() != "" || $('#from2').val() != "" && $('#till2').val() != "" && $('#in2').val() != "") {
            if ($('#from1').val() != "" && $('#till1').val() != "" && $('#in1').val() != "") {
                previousHabits.push({
                    from1: $('#from1').val(),
                    till1: $('#till1').val(),
                    in1: $('#in1').val()
                });
            }
            if ($('#from2').val() != "" && $('#till2').val() != "" && $('#in2').val() != "") {
                previousHabits.push({
                    from1: $('#from2').val(),
                    till1: $('#till2').val(),
                    in1: $('#in2').val()
                });
            }
        }
        jobs.forEach(function(e) {
            if(e != "") {
                job = e
            }
        })
        if(job == ""){
            if($('#unemployed').is(":checked")) {
                job = "unemployed"
            }
        }
        if (firstName != "" && lastName != "" && gender != "" && family != "" && size != "" && eyeColor != "" && dob != "" && job != "") {
            font = fonts[Math.floor(Math.random() * fonts.length)];
            var firstLetter = firstName.substr(0, 1);
            $('#signatureConfirm').hide();
            $("#signature").text(firstLetter.toUpperCase() + ". " + lastName.charAt(0).toUpperCase() + lastName.slice(1));
            $("#signature").css("font-family", font);
            $("#signature").css("font-size", "20px");
            signed = true;
            $('#close').show();
            SubmitDataToServer(firstName, lastName, gender, family, size, eyeColor, dob, job, font)
        } else {
            $('#signatureConfirm').hide();
            error("Bitte stelle sicher, dass die wichtigsten Felder ausgefüllt sind!")
        }
    })
    $("#yesIdentity").click(function () {
        $('#identityConfirm').hide();
        $.post("http://duke_identity/submitIdentity", JSON.stringify({}));
        return
    })
    $("#noIdentity").click(function () {
        $('#identityConfirm').hide();
        $.post("http://duke_identity/abortIdentity", JSON.stringify({}));
        return
    })
    $("#signNo").click(function () {
        $('#signatureConfirm').hide();
    })
    $("#sign").click(function () {
        if(signed == false) {
            $('#signatureConfirm').show();
        }
    })
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