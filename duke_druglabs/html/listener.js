var inHand = false;
var item = null;
var itemID = null;
var itemCount = null;
var itemName = null;
var back = false;
var interval = null;
var craft = false;

function sendMessage(msg) {
  $.post("http://duke_druglabs/msg", JSON.stringify({
    msg: msg
  }));
}

function startcraft(recipe) {
  var i = 0;
  if (i == 0) {
    i = 1;
    var elem = document.getElementById("bar-fill");
    var width = 1;
    var id = setInterval(frame, 10);
    function frame() {
      if (width >= 100) {
        clearInterval(id);
        i = 0;
        elem.style.width = "0%";
        itemName = recipe.split("_")[1].trim();
        var firstLetter = itemName.slice(0, 1)
        firstLetterCap = firstLetter.toUpperCase()
        itemName = itemName.replace(firstLetter, firstLetterCap)
        itemInSlot = $('#name').text().split("(")[0].trim()
        itemCount = $('#name').text().length
        if(itemCount == 0) {
          itemCount = 1
        } else {
          itemCount = parseInt($('#name').text().split("(")[1].split(")")[0].trim())
          itemCount += 1
        }
        if(itemInSlot == "") {
          $('#result').prepend("<tr onclick='result(event)'><td><img id='" + recipe + "' src='" +  itemName.toLowerCase() + ".png' /></td></tr>")
        }
        $('#name').html(itemName + " (" + itemCount + ")")
        craft = false;
      } else {
        width++;
        elem.style.width = width + "%";
      }
    }
  }
}

function getRecipe(recipe, returnRecipe) {
  recipe = JSON.stringify(recipe)
  var empty = "[null,null,null,null,null,null,null,null,null]"
  var meth = '["Trauben","Trauben","Trauben","Trauben","Grippepillen","Apfel","Apfel","Apfel","Apfel"]'
  var amphitamin = '["meth","meth","meth","meth","meth","meth","meth","meth","meth"]'
  if(returnRecipe == true) {
    if(recipe == empty) {
      return "empty"
    } else if(recipe == meth) {
      return "inventory_meth"
    } else if(recipe == amphitamin) {
      return "inventory_amphitamin"
    }
  } else {
    if(recipe == empty) {
      return true
    } else if(recipe == meth) {
      return true
    } else if(recipe == amphitamin) {
      return true
    } else {
      return false
    }
  }
}

function followCursor(id) {
  document.addEventListener('mousemove', function(ev){
    document.getElementById(id).style.transform = 'translateY('+(ev.clientY-370)+'px)';
    document.getElementById(id).style.transform += 'translateX('+(ev.clientX-440)+'px)';
    document.getElementById(id).style.zIndex = 1;
  },false);
}

function result(ev) {
  itemName = ev.target.id.split("_")[1].trim();
  var firstLetter = itemName.slice(0, 1)
  firstLetterCap = firstLetter.toUpperCase()
  itemName = itemName.replace(firstLetter, firstLetterCap)
  amount = parseInt($('#name').text().split("(")[1].split(")")[0].trim())
  $('#result tr').remove()
  $('#name').html("")
  var itemInInv = $('#inventory').find('td#' + ev.target.id).attr('id')
  if(itemInInv != null) {
    itemCount = parseInt($('#inventory').find('td#' + ev.target.id).text().split(":")[1].trim())
    itemName = $('#inventory').find('td#' + ev.target.id).text().split(":")[0].trim()
    itemCount = itemCount + amount
    $('#inventory').find('td#' + ev.target.id).html(itemName + ": " + itemCount)
  } else {
    itemName = ev.target.id.split("_")[1].trim()
    var firstLetter = itemName.slice(0, 1)
    firstLetterCap = firstLetter.toUpperCase()
    itemName = itemName.replace(firstLetter, firstLetterCap)
    $('#inventory').append("<tr><td id='" + ev.target.id + "' draggable='true' onclick='drag(event)'>" + itemName + ": " + amount + "</td></tr>");
  }
  $.post("http://duke_druglabs/addItem", JSON.stringify({
    item: itemName,
    amount: amount
  }));
}

function drag(ev) {
  if(inHand == true) {
    return
  } else {
    inHand = true;
    item = ev.target.innerText;
    itemID = ev.target.id;
    itemCount = item.split(":")[1].trim();
    setTimeout(function(){
      toggleBack(true)
    }, 1000)
    itemName = item.split(":")[0].trim();
    $('#drag_item').append(itemName + ": " + itemCount)
    $('#' + ev.target.id).hide();
    followCursor('drag_item');
  }
  //ev.dataTransfer.setData("text", ev.target.id);
  //$.post("http://duke_druglabs/msg", JSON.stringify({
  //  msg: ev.target.id
  //}));
  //$('table#inventory td#' + ev.target.id).remove();
  //while(document.body.onmousedown == true) {
  //  $('table#inventory td#' + ev.target.id).hide();
  //}
  //document.body.onmousedown = function() { 
  //  $('table#inventory td#' + ev.target.id).hide();
  //}
  //document.body.onmouseup = function() {
  //  $('table#inventory td#' + ev.target.id).show();
  //}
  //$(window).keydown(function(evt) {
  //  while(evt.which == 91) {
  //    setTimeout(sendMessage(evt.which), 5000)
  //  }
  //})
}

function toggleBack(bool) {
  back = bool;
}

function itemBack(ev) {
  var target = ev.target.id.trim()
  if(back == true) {
    if(target == "content" || target == "" || target == "buttons") {
      $('#' + itemID).text(itemName + ": " + itemCount);
      $('#' + itemID).show();
      $('#drag_item').text("");
      inHand = false;
      back = false;
    }
  }
}

function drop(ev) {
  var target = ev.target.id.trim()
  if(inHand == true) {
    if(target == "" || target == "inventory_filled") {
      return
    } else {
      var inv = ev.target.id.slice(0, 10)
      if(ev.target.id != itemName + "_img" && ev.target.id != "inventory" && ev.target.id != itemID && inv != "inventory_") {
        itemCount = parseInt(itemCount, 10);
        itemCount = itemCount -= 1;
        if(itemCount < 0) {
          itemCount = 0
          return
        }
        var field = ev.target.id.slice(-1)
        if(itemName == "Äpfel") {
          itemName = "Apfel";
        }
        if($('#field' + field + ' tr').attr('id') != null) {
          return
        }
        $('#' + ev.target.id).prepend("<tr id='" + itemID + "'><td><img id='" + itemName.toLowerCase() + "_img" + field + "' src='" + itemName + ".png' /></td></tr>")
        $('#drag_item').text(itemName + ": " + itemCount);
      } else {
        return
      }
    }
  } else {
    var isImage = target.slice(-5, -1)
    if(isImage == "_img") {
      field = target.slice(-1)
      itemID = $('#field' + field + ' tr').attr('id')
      itemName = target.replace("_img" + field, "")
      var firstLetter = itemName.slice(0, 1)
      firstLetterCap = firstLetter.toUpperCase()
      itemName = itemName.replace(firstLetter, firstLetterCap)
      item = $('#inventory td#' + itemID).text()
      itemCount = parseInt(item.split(":")[1].trim());
      itemCount = itemCount += 1
      if(itemName == "Apfel") {
        itemName = "Äpfel"
      }
      $('#' + itemID).text(itemName + ": " + itemCount);
      $('#field' + field + ' tr').remove();
    }
  }
}
$(function(){
    window.onload = function(e) {
        $('#container').hide();
        window.addEventListener("message", (event) => {
            var item = event.data;
            if(item !== undefined && item.type === "ui") {
                if(item.display === true) {
                    $('#name').html("")
                    $('#craftinggrid tr').remove()
                    $('#result tr').remove()
                    if(interval != null) {
                      clearInterval(interval)
                    }
                    $('#inventory tr').remove();
                    var inventory = jQuery.parseJSON(item.inventory)
                    loadInventory(inventory);
                    $('#container').show();
                } else {
                    $('#container').hide();
                }
            }
        })
    }
    $("#craft").click(function() {
      var arr = [];
      $('#craftinggrid div').each(function() {
        var tablerow = $('#' + this.id).find('tr').attr('id')
        var value = tablerow.split("_")[1].trim()
        var firstLetter = value.slice(0, 1)
        firstLetterCap = firstLetter.toUpperCase()
        value = value.replace(firstLetter, firstLetterCap)
        arr.push(value);
      })
      if(craft == true) {
        return
      } else {
        if(getRecipe(arr, false) == false) {
          $.post("http://duke_druglabs/error", JSON.stringify({
            error: "Dieses Rezept wurde nicht gefunden"
          }));
          return
        } else {
          var recipe = getRecipe(arr, true)
          itemName = recipe.split("_")[1].trim();
          var firstLetter = itemName.slice(0, 1)
          firstLetterCap = firstLetter.toUpperCase()
          itemName = itemName.replace(firstLetter, firstLetterCap)
          var itemInSlot = $('#name').text().split("(")[0].trim()
          if(recipe == "empty") {
            $.post("http://duke_druglabs/error", JSON.stringify({
              error: "Das Feld darf nicht leer sein"
            }));
            return
          }
          if(itemInSlot != "" && itemInSlot != itemName) {
            sendMessage(recipe)
            sendMessage(itemInSlot)
            return
          }
          $('#craftinggrid tr').remove()
          $.post("http://duke_druglabs/rmvItem", JSON.stringify({
            items: JSON.stringify(arr)
          }));
          startcraft(recipe)
        }
      }
    })
    $("#autocraft").click(function() {
      craft()
      interval = setInterval(() => {
        craft()
      }, 1000);
    })
    $("#close").click(function() {
      if(interval != null) {
        clearInterval(interval)
      }
      $.post("http://duke_druglabs/exit", JSON.stringify({}));
      return
  })
    function loadInventory(inventory) {
      if(inventory.Trauben != null) {
        $('#inventory').append("<tr><td id='inventory_trauben' draggable='true' onclick='drag(event)'>Trauben: " + inventory.Trauben + "</td></tr>");
      }
      if(inventory.Apfel != null) {
        $('#inventory').append("<tr><td id='inventory_apfel' draggable='true' onclick='drag(event)'>Äpfel: " + inventory.Apfel + "</td></tr>");
      }
      if(inventory.Medkits != null) {
        $('#inventory').append("<tr><td id='inventory_medkits' draggable='true' onclick='drag(event)'>Medkits: " + inventory.Medkits + "</td></tr>");
      }
      if(inventory.Reperaturkits != null) {
        $('#inventory').append("<tr><td id='inventory_repairkits' draggable='true' onclick='drag(event)'>Reperaturkits: " + inventory.Reperaturkits + "</td></tr>");
      }
      if(inventory.Grippepillen != null) {
        $('#inventory').append("<tr><td id='inventory_grippepillen' draggable='true' onclick='drag(event)'>Grippepillen: " + inventory.Grippepillen + "</td></tr>");
      }
      if(inventory.Meth != null) {
        $('#inventory').append("<tr><td id='inventory_meth' draggable='true' onclick='drag(event)'>Meth: " + inventory.Meth + "</td></tr>");
      }
    }
})
