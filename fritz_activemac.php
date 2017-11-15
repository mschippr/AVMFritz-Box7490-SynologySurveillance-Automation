#!/usr/bin/php

<?php
if(empty($argv[1])){
        die("FritzBox IP or IPs  missing");
}else{
        $ipList = explode(":",$argv[1]);
}
if(empty($argv[2])){
        die("MAC address or addresses missing");
}else{
	$macList = $argv;
	array_shift($macList);
}

function checkDevice($ip,$mac){
        $result = "";
        $uri = "urn:dslforum-org:service:Hosts:1";
        $location = "http://".$ip.":49000/upnp/control/hosts";
        $client = new SoapClient(
            null,
            array(
                'location'   => $location,
                'uri'        => $uri,
                'noroot'     => True,
                'login'      => "",
                'password'   => "",
                'connection_timeout' => 5
                )
        );
        try{
                $query = $client->GetSpecificHostEntry(new SoapParam($mac,'NewMACAddress'));
                $result = $query['NewActive'];
        }catch(SoapFault $fault){
                $result = 0;
        }
	return $result;
}

function checkAllDevices($ipList,$macList){
        $result = 0;
        foreach($ipList as $ip){
			foreach($macList as $mac){
				$resultCheck = checkDevice($ip,$mac);
				if($resultCheck == 1){
						$result = 1;
				}
			}
        }
        return $result;
}

echo checkAllDevices($ipList,$macList);
?>
