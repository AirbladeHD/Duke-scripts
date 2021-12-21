fx_version 'bodacious'
game 'gta5'

client_scripts {
    'client.lua',
    'functions.lua',
}

export 'PhoneAddApp'
export 'PhoneRemoveApp'

server_scripts {
    'server.lua',
    '@mysql-async/lib/MySQL.lua',
}

files {
    'html/index.html',
    'html/style.css',
    'html/listener.js',
    'html/phone.png',
    'html/bg2.jpg',
    'html/discord.png',
    'html/car.png',
    'html/youtube.png',
    'html/contacts.png',
	'html/loader.gif',
}

ui_page 'html/index.html'