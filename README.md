AVMFritz-Box7490-SynologySurveillance-Automation

Script makes soap queries to a list of AVM Fritz!Box routers to find out if a list of MAC addresses are active on the WiFi network. The PHP script has been written to accept at least one MAC but more can be added with a space

The shell script uses API calls to switch the HOME MODE option based on the result from the SOAP response.

The shell script has the IP of your Synology Surveillance Station and a login. On my SS i have setup a API user with only rights to enable/disable home mode i then use this user/pass in the script.

I have the SH and PHP files in the BIN directory and a state file in the ETC folder which stores the last state that was switched to stop constant API calls to the SS. You will need to grant appropriate file permissions and then run the shell script in a CRON job. I run mine once every 5 mins.

The script will perform a retry on leaving home mode just to ensure there is not too much flip/flopping of the home mode option if an issue occurs due to the WLAN devices switching, or dropping off the WLAN, etc.

Edit Switch_Homemode.sh configuration as requred.

Syntax: Switch_Homemode.sh MAC1 MAC2
