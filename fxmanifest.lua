fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Pappu'
description 'Playerlist for QBCore FiveM'
version '1.0.1'

shared_scripts {
	'config.lua',
}

server_scripts {
	'server/main.lua',
    'server/pappuupdate.lua',
}

client_scripts {
	'client/main.lua',
}

ui_page 'nui/index.html'

files {
    'nui/*',
    'nui/css/*',
    'nui/js/*',
    'nui/images/*',
}
