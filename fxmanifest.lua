fx_version 'adamant'
game 'gta5'

description 'test'
author 'nativeui'
version '1'


server_scripts {'@async/async.lua','@mysql-async/lib/MySQL.lua','sv/*.lua',}
client_script '@NativeUI/NativeUI.lua'
client_scripts {'cl/*.lua'}
shared_scripts {'shared/*.lua'}

ui_page {'html/html.html'}

files {'html/html.html','html/assets/js/*.js','html/assets/css/*.css','html/assets/img/*.png',}

