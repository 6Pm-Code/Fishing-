shared_script '@GT500/shared_fg-obfuscated.lua'
shared_script '@GT500/ai_module_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'

author 'Meine Eier 6Pm'
description 'Einfaches Angelsystem für FiveM'
version '1.0.0'

shared_script '@es_extended/imports.lua' -- Falls du ESX verwendest
shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'es_extended' -- Falls benötigt
}