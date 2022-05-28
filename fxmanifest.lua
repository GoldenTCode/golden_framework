-- Golden Framework --

fx_version 'adamant'
game 'gta5'

author 'Golden Development'
description 'Golden Framework'
version '1.0.0'

dependency 'mysql-async'

ui_page 'ui/index.html'

lua54 'yes'

shared_scripts {
    'shared/functions.lua',
    'config.lua'
}

client_scripts {
	'client/client.lua',
	'client/exports/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua',
	'server/exports/*.lua'
}

files {
	'server/db/framework.sql',
	'ui/index.html',
	'ui/assets/*.js',
	'ui/assets/*.css',
	'ui/assets/*.ttf'
}

framework_sql_file 'server/db/framework.sql'