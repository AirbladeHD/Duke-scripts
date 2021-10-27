fx_version 'bodacious'
game 'gta5'
ui_page 'html/index.html'
  
client_scripts {
    'config.lua',
    '@NativeUI/NativeUI.lua',
    '@updater/server.lua',
    '@inventoryApi/server.lua',
    'client.lua',
}

server_scripts {
    'config.lua',
    '@mysql-async/lib/MySQL.lua',
    '@inventoryApi/server.lua',
    'server.lua',
}

files {
    'html/index.html',
    'html/style.css',
    'html/reset.css',
    'html/listener.js',
}