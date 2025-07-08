Config = Config or {}
ColdGangs = ColdGangs or {}

fx_version 'cerulean'
game 'gta5'

author 'Cold-Gangs Dev Team'
description 'Cold-Gangs Full System'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/**/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**/*.lua'
}


ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/js/main.js'
}
