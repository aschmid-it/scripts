#!/bin/bash
# Scirpt to update a DDNS Record

# Namecheap

## Variables

HOST=@
DOMAIN=<domain>
PASS=<password>

PUBLIC_IP=$(dig -4 +short @1.1.1.1 ch txt whoami.cloudflare | awk -F'"' '{ print $2}')

## Options
LOGFILE=""
SILENT="false"

## Check for options
while getopts 'hsl:' option; do # The : specifies that this option needs an argument
    case ${option} in
        h) # Help
            echo "Syntax: update_ddns.sh [-h|-s|-l <logfile>]"
            echo
            echo "-h                Print Help."
            echo "-s                Silent mode."
            echo "-l <logfile>      Logfile."
            echo
            exit 0
            ;;
        l) # Logfile
            LOGFILE=${OPTARG}
            if [ ! -f "$LOGFILE" ]; then touch $LOGFILE; fi 
            if [ "$SILENT" = "false" ]; then echo "Logfile: $LOGFILE"; fi
            ;;
        s) # Silent
            SILENT="true"
            ;;
        ?) # Invalid option
            echo "Syntax: update_ddns.sh [-h|-s|-l <logfile>]"
            exit 1
            ;;        
    esac
done

## Get the current IP that is set on DNS
if [ "$HOST" = "@" ]
then
    DNS_IP=$(dig -4 +short @1.1.1.1 $DOMAIN | grep '^[0-9]')
else
    DNS_IP=$(dig -4 +short @1.1.1.1 $HOST.$DOMAIN | grep '^[0-9]')
fi

## Check if the DNS IP matches with the Public IP
if [ "$DNS_IP" = "$PUBLIC_IP" ]
then
    if [ "$SILENT" = "false" ]; then echo "IP ($PUBLIC_IP) already correct."; fi
    if [ "$LOGFILE" != "" ]; then echo "[`date`] IP ($PUBLIC_IP) already correct." >> $LOGFILE; fi
else
    RESULT=$(curl -s "https://dynamicdns.park-your-domain.com/update?host=$HOST&domain=$DOMAIN&password=$PASS&ip=$PUBLIC_IP")
    if [ "$RESULT" != "" ]
    then
        if [ "$SILENT" = "false" ]; then echo "Error ($RESULT) setting IP."; fi
        if [ "$LOGFILE" != "" ]; then echo "[`date`] Error ($RESULT) setting IP." >> $LOGFILE; fi
    else
        if [ "$SILENT" = "false" ]; then echo "Set DDNS IP for $HOST.$DOMAIN to $PUBLIC_IP."; fi
        if [ "$LOGFILE" != "" ]; then echo "[`date`] ESet DDNS IP for $HOST.$DOMAIN to $PUBLIC_IP." >> $LOGFILE; fi
    fi
fi

exit 0

# DigitalOcean
#
#################### CHANGE THE FOLLOWING VARIABLES ####################
# TOKEN="abcdef1234567890"
# DOMAIN="yourdomain.info"
# RECORD_ID="111222333"
# LOG_FILE="/home/youruser/ips.txt"
########################################################################

# CURRENT_IPV4="$(dig +short myip.opendns.com @resolver1.opendns.com)"
# LAST_IPV4="$(tail -1 $LOG_FILE | awk -F, '{print $2}')"
# 
# if [ "$CURRENT_IPV4" = "$LAST_IPV4" ]; then
#     echo "IP has not changed ($CURRENT_IPV4)"
# else
#     echo "IP has changed: $CURRENT_IPV4"
#     echo "$(date),$CURRENT_IPV4" >> "$LOG_FILE"
#     curl -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"data":"'"$CURRENT_IPV4"'"}' "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$RECORD_ID"
# fi