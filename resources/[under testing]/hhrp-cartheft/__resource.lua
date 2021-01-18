-------------------------------------
------- Created by 5M.WT ------------
------------------------------------- 

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'T1GER Car Thief'

author 'T1GER#9080'

server_scripts {
	'@hhrp-core/locale.lua',
	'locales/en.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/server.lua'
}

client_scripts {
	'@hhrp-core/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/utils.lua',
	'client/client.lua'
}
