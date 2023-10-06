fx_version 'cerulean'
game 'gta5'

description 'QB-TaxiJob'
version '1.0.0'

ui_page 'html/index.html'
files {
    'html/index.html',
	'html/js/coupon.js',
	'html/js/meter.js',
	'html/css/coupon.css',
	'html/css/meter.css',
	'html/css/reset.css',
	'html/img/g5-meter.png',
	'html/img/downtown_cab_co_coupon.png',
	'html/img/downtown_cab_co_coupon_gold.png'
}

shared_scripts {
	'@qb-core/shared/locale.lua',
	'locales/en.lua', -- Change to the language you want to use
	'config/*.lua',
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',

    'client/__main.lua',

    'client/functions/*.lua',
    'client/services/*.lua',

    'client/events.lua',
	'client/threads.lua',
}

server_scripts {
    'server/*.lua',
}

dependencies {
	'qb-core',
	'PolyZone',
    'ps-fuel',
    'mz-skills'
}

lua54 'yes'
