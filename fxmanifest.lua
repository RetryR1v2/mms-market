fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'mms-market'
version '1.1.2'
author 'Markus Mueller'

client_scripts {
	'client/client.lua'
}

server_scripts {
	'server/server.lua',
	'@oxmysql/lib/MySQL.lua',
}

shared_scripts {
    'config.lua',
	'shared/locale.lua',
	'languages/*.lua',
}

dependency {
	'vorp_core',
}

lua54 'yes'