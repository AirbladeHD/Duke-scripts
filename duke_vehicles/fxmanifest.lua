fx_version 'bodacious'
game 'gta5'
ui_page 'html/index.html'
  
client_scripts {
    'config.lua',
    'client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
}

files {
    'html/index.html',
    'html/style.css',
    'html/listener.js',
}