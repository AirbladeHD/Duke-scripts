fx_version 'bodacious'
game 'gta5'
ui_page 'html/index.html'
  
client_scripts {
    '@NativeUI/NativeUI.lua',
    '@duke_notifications/functions.lua',
    'client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@duke_notifications/functions.lua',
    '@duke_inventoryAPI/functions.lua',
    'server.lua',
}

files {
    'html/*',
}