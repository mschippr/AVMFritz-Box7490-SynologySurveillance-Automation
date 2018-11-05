#!/bin/bash

######## Configuration
SYNO_SS_USER="api_user";
SYNO_SS_PASS="pass";
SYNO_URL="192.168.1.1:5000";
FRITZ_URL='192.168.1.2:192.168.1.3';
STATEFILE='/var/services/homes/api_user/synohomemode.state';
RETRYFILE='/var/services/homes/api_user/synohomemode.retry';
CHECKFRITZ='/usr/local/bin/php70 /var/services/homes/api_user/fritz_activemac.php';

######### Internal variables ############
MACS=$@;
ID="$RANDOM";
COOKIESFILE="$0-cookies-$ID";

###### Functions
function _switchHomemode ()
{
wget -q --keep-session-cookies --save-cookies $COOKIESFILE -O- "http://${SYNO_URL}//webapi/auth.cgi?api=SYNO.API.Auth&method=Login&version=3&account=${SYNO_SS_USER}&passwd=${SYNO_SS_PASS}&session=SurveillanceStation";
wget -q --load-cookies $COOKIESFILE -O- "http://${SYNO_URL}//webapi/entry.cgi?api=SYNO.SurveillanceStation.HomeMode&version=1&method=Switch&on=${1}";
wget -q --load-cookies $COOKIESFILE -O- "http://${SYNO_URL}/webapi/auth.cgi?api=SYNO.API.Auth&method=Logout&version=1";
rm $COOKIESFILE;
rm $STATEFILE;
echo $1 > $STATEFILE;
}

if [ $# -eq 0 ]; then
	echo "MAC address or addresses missing"
	exit 1;
fi

if [ -f $STATEFILE ]; then
	result=$($CHECKFRITZ $FRITZ_URL $MACS);
	if [ $result -eq 1 ] && grep -q false $STATEFILE; then
		_switchHomemode "true";
	elif [ -f $RETRYFILE ]; then
		if [ $result -eq 0 ] && grep -q true $STATEFILE; then
			_switchHomemode "false";
			rm $RETRYFILE;
		else
			rm $RETRYFILE;
		fi
        elif [ $result -eq 0 ] && grep -q true $STATEFILE; then
                echo retry > $RETRYFILE;
	fi
else
	echo false > $STATEFILE;
fi
exit 0;
