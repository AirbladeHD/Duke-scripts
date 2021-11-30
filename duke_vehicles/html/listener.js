var currentVehicle = 0
var SpoilerCount = 0
var currentSpoiler = 0
var modCount = 0
var current = -1

var mods_list = [
    ["Spoiler", 0],
    ["Bumper", 0],
    ["Skirt", 0],
    ["Auspuff", 0],
    ["Fahrwerk", 0]
]

function switchMod(item, d) {
    mods_list[item][1] = mods_list[item][1] + d;
    if(mods_list[item][1] > modCount[item]) {
        mods_list[item][1] = 0
        $('#' + mods_list[item][0]).html("Standart " + mods_list[item][0]);
                $.post("http://duke_vehicles/reloadMods", JSON.stringify({
            c: currentVehicle
        }));
        return
    }
    if(mods_list[item][1] == 0) {
        $('#' + mods_list[item][0]).html("Standart " + mods_list[item][0]);
                $.post("http://duke_vehicles/reloadMods", JSON.stringify({
            c: currentVehicle
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
                item.mods.forEach(resetList);
                $('#vehicle_price').html("Preis: " + item.price + "$");
                $('#vehicle_name').html(item.brand + " " + item.name);
                item.mods.forEach(appendMods);
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
                    item.mods.forEach(appendMods);
                }
                $('#vehicle_price').html("Preis: " + item.price + "$");
                $('#vehicle_name').html(item.brand + " " + item.name);
            }
        })
    }
    function appendMods(item) {
        if(modCount[item] == -1 || modCount[item] == undefined) {
            return
        } else {
            if(modCount[item] == 0) {
                modCount[item] = 1;
            }
            $('#mods').append('<tr><td><div class="adjustment_switcher"><svg id="left_' + item + '" onClick="switchMod(' + item + ', -1)" class="left" data-name="Ebene 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><path style="fill: #fff;" d="M809.24,193.07,674.07,461.8l-19.16,38.09L674,538,810.16,810.39,190.52,501.5,809.24,193.07M1000,3,0,501.5,1000,1000,750,500,1000,3Z"/></svg><p id="' + mods_list[item][0] + '">Standart ' + mods_list[item][0] + '</p><svg id="right_' + item + '" onClick="switchMod(' + item + ', 1)" class="right" data-name="Ebene 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><path style="fill: #fff;" d="M190.76,193.07,809.48,501.5,189.84,810.39,326,538l19.06-38.12L325.93,461.8,190.76,193.07M0,3,250,500,0,1000,1000,501.5,0,3Z"/></svg></div></td></tr>')
        }
    }
    $('#spoiler_right').click(function(){
        if(SpoilerCount == undefined || SpoilerCount == -1) {
            return
        }
        currentSpoiler += 1
        if(currentSpoiler > SpoilerCount) {
            currentSpoiler = 0
            $('#spoiler_name').html('Kein Spoiler');
            $.post("http://duke_vehicles/switch", JSON.stringify({
                d: "reload",
                c: currentVehicle
            }));
            return
        }
        $('#spoiler_name').html('Spoiler: ' + currentSpoiler + "/" + SpoilerCount);
        $.post("http://duke_vehicles/switch_mod", JSON.stringify({
            m: 0,
            c: currentSpoiler
        }));
    })
    $('#spoiler_left').click(function(){
        if(SpoilerCount == undefined || SpoilerCount == -1) {
            return
        }
        currentSpoiler -= 1
        if(currentSpoiler == 0) {
            $('#spoiler_name').html('Kein Spoiler');
            $.post("http://duke_vehicles/switch", JSON.stringify({
                d: "reload",
                c: currentVehicle
            }));
            return
        } else if(currentSpoiler < 0) {
            currentSpoiler = SpoilerCount
            $('#spoiler_name').html('Spoiler: ' + SpoilerCount + "/" + SpoilerCount);
            $.post("http://duke_vehicles/switch_mod", JSON.stringify({
                m: 0,
                c: currentSpoiler
            }));
            return
        }
        $('#spoiler_name').html('Spoiler: ' + currentSpoiler + "/" + SpoilerCount);
        $.post("http://duke_vehicles/switch_mod", JSON.stringify({
            m: 0,
            c: currentSpoiler
        }));
    })
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