fx_version 'cerulean'
game 'gta5'

description 'QB-TaxiJob'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
	'@qb-core/shared/locale.lua',
	'locales/en.lua', -- Change to the language you want to use
	'config.lua',
}

dependencies {
	'qb-core',
	'PolyZone',
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
	'client/main.lua',
    'client/coupon.lua'
}

server_scripts {
    'server/main.lua',
    'server/coupon.lua'
}

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

lua54 'yes'
