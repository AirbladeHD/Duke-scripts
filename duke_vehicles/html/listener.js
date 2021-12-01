var currentVehicle = 0
var SpoilerCount = 0
var currentSpoiler = 0
var modCount = 0
var current = -1
var i = 0
var currentList = {}

var mods_list = [
    ["Spoiler", 0],
    ["Stoßstange_V", 0],
    ["Stoßstange_H", 0],
    ["Unterboden", 0],
    ["Auspuff", 0],
    ["Fahrwerk", 0],
    ["Kühler", 0],
    ["Haube", 0],
    ["Flügel_L", 0],
    ["Flügel_R", 0],
    ["Dach", 0],
    ["Motor", 0],
    ["Bremsen", 0],
    ["Getriebe", 0],
    ["Hupe", 0],
    ["Federung", 0],
    ["Panzerung", 0],
    ["Nitro", 0],
    ["Turbo", 0],
    ["Subwoofer", 0],
    ["Qualm", 0],
    ["Hydraulik", 0],
    ["Xenon", 0],
    ["Räder", 0],
    ["Räder_H", 0],
    ["Kennzeichenhalter", 0],
    ["Customkennzeichen", 0],
    ["Innenraum_1", 0],
    ["Innenraum_2", 0],
    ["Innenraum_3", 0],
    ["Innenraum_4", 0],
    ["Innenraum_5", 0],
    ["Sitze", 0],
    ["Lenkrad", 0],
    ["Knopf", 0],
    ["Plaque", 0],
    ["Eis", 0],
    ["Kofferraum", 0],
    ["Hydro", 0],
    ["Motorraum_1", 0],
    ["Motorraum_2", 0],
    ["Motorraum_3", 0],
    ["Fahrwerk_2", 0],
    ["Fahrwerk_3", 0],
    ["Fahrwerk_4", 0],
    ["Fahrwerk_5", 0],
    ["Tür_L", 0],
    ["Tür_R", 0],
    ["Leihe", 0],
    ["Lichtleiste", 0],
]

function switchMod(item, d) {
    mods_list[item][1] = mods_list[item][1] + d;
    if(mods_list[item][1] > currentList.indexOf(item)) {
        mods_list[item][1] = 0
        $('#' + mods_list[item][0]).html("Standart " + mods_list[item][0]);
                $.post("http://duke_vehicles/reloadMods", JSON.stringify({
            c: currentVehicle,
            mods: mods_list
        }));
        return
    }
    if(mods_list[item][1] == 0) {
        $('#' + mods_list[item][0]).html("Standart " + mods_list[item][0]);
                $.post("http://duke_vehicles/reloadMods", JSON.stringify({
            c: currentVehicle,
            mods: mods_list
        }));
        return
    }
    if(mods_list[item][1] < 0) {
        mods_list[item][1] = modCount[item];
    }
    $('#' + mods_list[item][0]).html(mods_list[item][0] + ": " + mods_list[item][1] + "/" + modCount[item]);
    $.post("http://duke_vehicles/switch_mod", JSON.stringify({
        m: item,
        c: mods_list[item][1]
    }));
}

function resetList(item) {
    mods_list[item][1] = 0;
}

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
                SpoilerCount = item.spoilers
                hp.style.strokeDashoffset = 314*(1 + (item.hp/1000));
                turbo.style.strokeDashoffset = 314*(1 + (item.turbo/1000));
                traktion.style.strokeDashoffset = 314*(1 + (item.traktion/1000));
                handling.style.strokeDashoffset = 314*(1 + (item.handling/1000));
                modCount = item.modCount;
                $('#mods tr').remove();
                item.mods.forEach(resetList);
                $('#vehicle_price').html("Preis: " + item.price + "$");
                $('#vehicle_name').html(item.brand + " " + item.name);
                i = 0;
                currentList = {}
                item.mods.forEach(appendMods);
                i = 0;
                currentList = {}
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
                SpoilerCount = item.spoilers
                hp.style.strokeDashoffset = 314*(1 + (item.hp/1000));
                turbo.style.strokeDashoffset = 314*(1 + (item.turbo/1000));
                traktion.style.strokeDashoffset = 314*(1 + (item.traktion/1000));
                handling.style.strokeDashoffset = 314*(1 + (item.handling/1000));
                modCount = item.modCount;
                if(item.reset != 0) {
                    $('#mods tr').remove();
                    item.mods.forEach(resetList);
                    i = 0;
                    currentList = {}
                    item.mods.forEach(appendMods);
                    i = 0;
                    currentList = {}
                }
                $('#vehicle_price').html("Preis: " + item.price + "$");
                $('#vehicle_name').html(item.brand + " " + item.name);
            }
        })
    }
    function appendMods(item) {
        if(modCount[i] == -1 || modCount[i] == undefined) {
            return
        } else {
            if(modCount[i] == 0) {
                modCount[i] = 1;
            }
            currentList.push(item)
            i += 1
            $('#mods').append('<tr><td><div class="adjustment_switcher"><svg id="left_' + item + '" onClick="switchMod(' + item + ', -1)" class="left" data-name="Ebene 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><path style="fill: #fff;" d="M809.24,193.07,674.07,461.8l-19.16,38.09L674,538,810.16,810.39,190.52,501.5,809.24,193.07M1000,3,0,501.5,1000,1000,750,500,1000,3Z"/></svg><p id="' + mods_list[item][0] + '">Standart ' + mods_list[item][0] + '</p><svg id="right_' + item + '" onClick="switchMod(' + item + ', 1)" class="right" data-name="Ebene 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><path style="fill: #fff;" d="M190.76,193.07,809.48,501.5,189.84,810.39,326,538l19.06-38.12L325.93,461.8,190.76,193.07M0,3,250,500,0,1000,1000,501.5,0,3Z"/></svg></div></td></tr>')
        }
    }
    $('#primary').on('input', function() {
        var color = $(this).val();
        $.post("http://duke_vehicles/primary", JSON.stringify({
            color: color
        }));
    });
    $('#secondary').on('input', function() {
        var color = $(this).val();
        $.post("http://duke_vehicles/secondary", JSON.stringify({
            color: color
        }));
    });
    $('#buy').click(function(){
        $('#mods tr').remove();
        vname = $('#vehicle_name').text().split(" ")
        $.post("http://duke_vehicles/buy", JSON.stringify({
            n: vname[1],
            m: vname[0],
            p: $('#vehicle_price').text(),
            primary: $('#primary').val(),
            secondary: $('#secondary').val(),
            mods: mods_list
        }));
    })
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
        $('#mods tr').remove();
        $.post("http://duke_vehicles/exit", JSON.stringify({}));
        return
    })
    $('#suv').click(function(){
        $.post("http://duke_vehicles/switch_cat", JSON.stringify({
            cat: 1
        }));
    })
    $('#luxus').click(function(){
        $.post("http://duke_vehicles/switch_cat", JSON.stringify({
            cat: 2
        }));
    })
    $('#sport').click(function(){
        $.post("http://duke_vehicles/switch_cat", JSON.stringify({
            cat: 3
        }));
    })
    $('#supersport').click(function(){
        $.post("http://duke_vehicles/switch_cat", JSON.stringify({
            cat: 4
        }));
    })
    $('#motorrad').click(function(){
        $.post("http://duke_vehicles/switch_cat", JSON.stringify({
            cat: 5
        }));
    })
})