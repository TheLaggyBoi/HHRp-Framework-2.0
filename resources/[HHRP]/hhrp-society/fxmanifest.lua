fx_version 'adamant'
games { 'gta5' }

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@hhrp-core/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@hhrp-core/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'hhrp-core',
	'cron',
	'hhrp-addonaccount'
}
