#!/bin/zsh

# Author: Andrew W. Johnson
# Organization: Stony Brook University/DoIT
# 
# This wjamf script will set the time server and timezone of the computer. Usually it is run
# at first setup before binding to the AD in order to be sure the clocks are properly synched
# Pass the timeserver address or IP in the first paramater (Jamf = #4) and the timezone in 
# the second paramater (Jamf - #5). For a list of timezones see the bottom of the script.
# 
# 
# Date: 2020.02.13
# Version: 2.00
# Re-Write
#
# Date: 2020.02.13
# Version: 2.10
# Changes:
#	Added the list of timezones in the comments at the end of the script
#	Changed to pass the timeserver and timezone to the script via the paramaters.
#	Commented the code... Sorta...


myTimeServer=${4}
	# America/New_York
myTimeZone=${5}

	# Get the script name.
SCRIPT_NAME=$( /usr/bin/basename "${0}" )
/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${SCRIPT_NAME} - v2.00 ("`/bin/date`")" >> /var/log/jamf.log

	# Check to see if the networktime is on.
USENETWORKTIME=$( /usr/sbin/systemsetup -getusingnetworktime | /usr/bin/awk -F " " {'print $3'} )

	# If it's not on, then turn it on. I don't remember why I lopped this bit... Maybe because sometimes it would need a few tries to set it??
if [ ${USENETWORKTIME} != "On" ]; then
	while [ ${USENETWORKTIME} != "On" ]
	do
    	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Network time is off." >> /var/log/jamf.log
		/bin/echo "Network time is off."
        /bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Setting Network Time to on..." >> /var/log/jamf.log
		/bin/echo "Setting Network Time to on..."
		/usr/sbin/systemsetup -setusingnetworktime on > /dev/null 2>&1
		USENETWORKTIME=$( /usr/sbin/systemsetup -getusingnetworktime | /usr/bin/awk -F " " {'print $3'} )
	done
else
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Network time is set to on." >> /var/log/jamf.log
    /bin/echo "Network time is set to on."
fi

	# Check to see if the time server is set. I don't remember why I lopped this bit... Maybe because sometimes it would need a few tries to set it??
TIMESERVER=`/usr/sbin/systemsetup -getnetworktimeserver | /usr/bin/awk -F " " {'print $4'}`

if [ $TIMESERVER != "${myTimeServer}" ]; then
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Network time server is not set correctly." >> /var/log/jamf.log
	/bin/echo "Network time server is not set correctly."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Setting Network Time Server to: time.stonybrook.edu" >> /var/log/jamf.log
	/bin/echo "Setting Network Time Server to: ${myTimeServer}"
	/usr/sbin/systemsetup -setnetworktimeserver "${myTimeServer}" > /dev/null 2>&1
else
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Network time server is set to ${myTimeServer}." >> /var/log/jamf.log
	/bin/echo "Network time server is set to ${myTimeServer}."
fi

	# Check to see if the timezone is set. I don't remember why I lopped this bit... Maybe because sometimes it would need a few tries to set it??
TIMEZONE=`/usr/sbin/systemsetup -gettimezone | /usr/bin/awk -F " " {'print $3'}`

if [ ${TIMEZONE} != "${myTimeZone}" ]; then
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Time Zone is not set correctly." >> /var/log/jamf.log
	/bin/echo "Time Zone is not set correctly."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Setting Time Zone to: ${myTimeZone}" >> /var/log/jamf.log
    /bin/echo "Setting Time Zone to: ${myTimeZone}"
	/usr/sbin/systemsetup -settimezone "${myTimeZone}" > /dev/null 2>&1
else
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: Time Zone is set to ${myTimeZone}." >> /var/log/jamf.log
	/bin/echo "Time Zone is set to ${myTimeZone}."
fi

exit 0



# Time Zones as of (2022.02.03):
# Africa/Abidjan			America/Adak					Antarctica/Casey			Asia/Aden			Atlantic/Azores			Australia/Adelaide		Europe/Amsterdam	Indian/Antananarivo		Pacific/Apia
# Africa/Accra				America/Anchorage				Antarctica/Davis			Asia/Almaty			Atlantic/Bermuda		Australia/Brisbane		Europe/Andorra		Indian/Chagos			Pacific/Auckland
# Africa/Addis_Ababa		America/Anguilla				Antarctica/DumontDUrville	Asia/Amman			Atlantic/Canary			Australia/Broken_Hill	Europe/Astrakhan	Indian/Christmas		Pacific/Bougainville
# Africa/Algiers			America/Antigua					Antarctica/Macquarie		Asia/Anadyr			Atlantic/Cape_Verde		Australia/Currie		Europe/Athens		Indian/Cocos			Pacific/Chatham
# Africa/Asmara				America/Araguaina				Antarctica/Mawson			Asia/Aqtau			Atlantic/Faroe			Australia/Darwin		Europe/Belgrade		Indian/Comoro			Pacific/Chuuk
# Africa/Bamako				America/Argentina/Buenos_Aires	Antarctica/McMurdo			Asia/Aqtobe			Atlantic/Madeira		Australia/Eucla			Europe/Berlin		Indian/Kerguelen		Pacific/Easter
# Africa/Bangui				America/Argentina/Catamarca		Antarctica/Palmer			Asia/Ashgabat		Atlantic/Reykjavik		Australia/Hobart		Europe/Bratislava	Indian/Mahe				Pacific/Efate
# Africa/Banjul				America/Argentina/Cordoba		Antarctica/Rothera			Asia/Atyrau			Atlantic/South_Georgia	Australia/Lindeman		Europe/Brussels		Indian/Maldives			Pacific/Enderbury
# Africa/Bissau				America/Argentina/Jujuy			Antarctica/South_Pole		Asia/Baghdad		Atlantic/St_Helena		Australia/Lord_Howe		Europe/Bucharest	Indian/Mauritius		Pacific/Fakaofo
# Africa/Blantyre			America/Argentina/La_Rioja		Antarctica/Syowa			Asia/Bahrain		Atlantic/Stanley		Australia/Melbourne		Europe/Budapest		Indian/Mayotte			Pacific/Fiji
# Africa/Brazzaville		America/Argentina/Mendoza		Antarctica/Troll			Asia/Baku									Australia/Perth			Europe/Busingen		Indian/Reunion			Pacific/Funafuti
# Africa/Bujumbura			America/Argentina/Rio_Gallegos	Antarctica/Vostok			Asia/Bangkok								Australia/Sydney		Europe/Chisinau								Pacific/Galapagos
# Africa/Cairo				America/Argentina/Salta			Arctic/Longyearbyen			Asia/Barnaul														Europe/Copenhagen							Pacific/Gambier
# Africa/Casablanca			America/Argentina/San_Juan									Asia/Beirut															Europe/Dublin								Pacific/Guadalcanal
# Africa/Ceuta				America/Argentina/San_Luis									Asia/Bishkek														Europe/Gibraltar							Pacific/Guam
# Africa/Conakry			America/Argentina/Tucuman									Asia/Brunei															Europe/Guernsey								Pacific/Honolulu
# Africa/Dakar				America/Argentina/Ushuaia									Asia/Calcutta														Europe/Helsinki								Pacific/Johnston
# Africa/Dar_es_Salaam		America/Aruba												Asia/Chita															Europe/Isle_of_Man							Pacific/Kanton
# Africa/Djibouti			America/Asuncion											Asia/Choibalsan														Europe/Istanbul								Pacific/Kiritimati
# Africa/Douala				America/Atikokan											Asia/Chongqing														Europe/Jersey								Pacific/Kosrae
# Africa/El_Aaiun			America/Bahia												Asia/Colombo														Europe/Kaliningrad							Pacific/Kwajalein
# Africa/Freetown			America/Bahia_Banderas										Asia/Damascus														Europe/Kiev									Pacific/Majuro
# Africa/Gaborone			America/Barbados											Asia/Dhaka															Europe/Kirov								Pacific/Marquesas
# Africa/Harare				America/Belem												Asia/Dili															Europe/Lisbon								Pacific/Midway
# Africa/Johannesburg		America/Belize												Asia/Dubai															Europe/Ljubljana							Pacific/Nauru
# Africa/Juba				America/Blanc-Sablon										Asia/Dushanbe														Europe/London								Pacific/Niue
# Africa/Kampala			America/Boa_Vista											Asia/Famagusta														Europe/Luxembourg							Pacific/Norfolk
# Africa/Khartoum			America/Bogota												Asia/Gaza															Europe/Madrid								Pacific/Noumea
# Africa/Kigali				America/Boise												Asia/Harbin															Europe/Malta								Pacific/Pago_Pago
# Africa/Kinshasa			America/Cambridge_Bay										Asia/Hebron															Europe/Mariehamn							Pacific/Palau
# Africa/Lagos				America/Campo_Grande										Asia/Ho_Chi_Minh													Europe/Minsk								Pacific/Pitcairn
# Africa/Libreville			America/Cancun												Asia/Hong_Kong														Europe/Monaco								Pacific/Pohnpei
# Africa/Lome				America/Caracas												Asia/Hovd															Europe/Moscow								Pacific/Ponape
# Africa/Luanda				America/Cayenne												Asia/Irkutsk														Europe/Oslo									Pacific/Port_Moresby
# Africa/Lubumbashi			America/Cayman												Asia/Jakarta														Europe/Paris								Pacific/Rarotonga
# Africa/Lusaka				America/Chicago												Asia/Jayapura														Europe/Podgorica							Pacific/Saipan
# Africa/Malabo				America/Chihuahua											Asia/Jerusalem														Europe/Prague								Pacific/Tahiti
# Africa/Maputo				America/Costa_Rica											Asia/Kabul															Europe/Riga									Pacific/Tarawa
# Africa/Maseru				America/Creston												Asia/Kamchatka														Europe/Rome									Pacific/Tongatapu
# Africa/Mbabane			America/Cuiaba												Asia/Karachi														Europe/Samara								Pacific/Truk
# Africa/Mogadishu			America/Curacao												Asia/Kashgar														Europe/San_Marino							Pacific/Wake
# Africa/Monrovia			America/Danmarkshavn										Asia/Kathmandu														Europe/Sarajevo								Pacific/Wallis
# Africa/Nairobi			America/Dawson												Asia/Katmandu														Europe/Saratov
# Africa/Ndjamena			America/Dawson_Creek										Asia/Khandyga														Europe/Simferopol
# Africa/Niamey				America/Denver												Asia/Krasnoyarsk													Europe/Skopje
# Africa/Nouakchott			America/Detroit												Asia/Kuala_Lumpur													Europe/Sofia
# Africa/Ouagadougou		America/Dominica											Asia/Kuching														Europe/Stockholm
# Africa/Porto-Novo			America/Edmonton											Asia/Kuwait															Europe/Tallinn
# Africa/Sao_Tome			America/Eirunepe											Asia/Macau															Europe/Tirane
# Africa/Tripoli			America/El_Salvador											Asia/Magadan														Europe/Ulyanovsk
# Africa/Tunis				America/Fort_Nelson											Asia/Makassar														Europe/Uzhgorod
# Africa/Windhoek			America/Fortaleza											Asia/Manila															Europe/Vaduz
# 							America/Glace_Bay											Asia/Muscat															Europe/Vatican
# 							America/Godthab												Asia/Nicosia														Europe/Vienna
# 							America/Goose_Bay											Asia/Novokuznetsk													Europe/Vilnius
# 							America/Grand_Turk											Asia/Novosibirsk													Europe/Volgograd
# 							America/Grenada												Asia/Omsk															Europe/Warsaw
# 							America/Guadeloupe											Asia/Oral															Europe/Zagreb
# 							America/Guatemala											Asia/Phnom_Penh														Europe/Zaporozhye
# 							America/Guayaquil											Asia/Pontianak														Europe/Zurich
# 							America/Guyana												Asia/Pyongyang														GMT
# 							America/Halifax												Asia/Qatar
# 							America/Havana												Asia/Qostanay
# 							America/Hermosillo											Asia/Qyzylorda
# 							America/Indiana/Indianapolis								Asia/Rangoon
# 							America/Indiana/Knox										Asia/Riyadh
# 							America/Indiana/Marengo										Asia/Sakhalin
# 							America/Indiana/Petersburg									Asia/Samarkand
# 							America/Indiana/Tell_City									Asia/Seoul
# 							America/Indiana/Vevay										Asia/Shanghai
# 							America/Indiana/Vincennes									Asia/Singapore
# 							America/Indiana/Winamac										Asia/Srednekolymsk
# 							America/Inuvik												Asia/Taipei
# 							America/Iqaluit												Asia/Tashkent
# 							America/Jamaica												Asia/Tbilisi
# 							America/Juneau												Asia/Tehran
# 							America/Kentucky/Louisville									Asia/Thimphu
# 							America/Kentucky/Monticello									Asia/Tokyo
# 							America/Kralendijk											Asia/Tomsk
# 							America/La_Paz												Asia/Ulaanbaatar
# 							America/Lima												Asia/Urumqi
# 							America/Los_Angeles											Asia/Ust-Nera
# 							America/Lower_Princes										Asia/Vientiane
# 							America/Maceio												Asia/Vladivostok
# 							America/Managua												Asia/Yakutsk
# 							America/Manaus												Asia/Yangon
# 							America/Marigot												Asia/Yekaterinburg
# 							America/Martinique											Asia/Yerevan
# 							America/Matamoros
# 							America/Mazatlan
# 							America/Menominee
# 							America/Merida
# 							America/Metlakatla
# 							America/Mexico_City
# 							America/Miquelon
# 							America/Moncton
# 							America/Monterrey
# 							America/Montevideo
# 							America/Montreal
# 							America/Montserrat
# 							America/Nassau
# 							America/New_York
# 							America/Nipigon
# 							America/Nome
# 							America/Noronha
# 							America/North_Dakota/Beulah
# 							America/North_Dakota/Center
# 							America/North_Dakota/New_Salem
# 							America/Nuuk
# 							America/Ojinaga
# 							America/Panama
# 							America/Pangnirtung
# 							America/Paramaribo
# 							America/Phoenix
# 							America/Port-au-Prince
# 							America/Port_of_Spain
# 							America/Porto_Velho
# 							America/Puerto_Rico
# 							America/Punta_Arenas
# 							America/Rainy_River
# 							America/Rankin_Inlet
# 							America/Recife
# 							America/Regina
# 							America/Resolute
# 							America/Rio_Branco
# 							America/Santa_Isabel
# 							America/Santarem
# 							America/Santiago
# 							America/Santo_Domingo
# 							America/Sao_Paulo
# 							America/Scoresbysund
# 							America/Shiprock
# 							America/Sitka
# 							America/St_Barthelemy
# 							America/St_Johns
# 							America/St_Kitts
# 							America/St_Lucia
# 							America/St_Thomas
# 							America/St_Vincent
# 							America/Swift_Current
# 							America/Tegucigalpa
# 							America/Thule
# 							America/Thunder_Bay
# 							America/Tijuana
# 							America/Toronto
# 							America/Tortola
# 							America/Vancouver
# 							America/Whitehorse
# 							America/Winnipeg
# 							America/Yakutat
# 							America/Yellowknife