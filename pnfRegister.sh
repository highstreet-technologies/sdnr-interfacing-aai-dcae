#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE

. config;
      pnfType=${1,,};
  onapVersion="$2";
       domain="other";

# exception for controller alarms
if [ "$onapVersion" == "Casablanca" ]
  then
    domain="pnfRegistration";
fi

declare -A mapping=(
    [controllerName]=$(hostname --fqdn)
    [domain]=$domain
    [eventId]="${pnfIdByType[$pnfType]}_${modelByType[$pnfType]}"
    [eventTime]=${eventTime}
    [eventType]=EventType5G
    [pnfId]=${pnfIdByType[$pnfType]}
    [type]=${pnfType^^}
    [model]=${modelByType[$pnfType]}
    [oamIp]=${oamIpByType[$pnfType]}
    [oamIpV6]=0:0:0:0:0:ffff:a0a:0${oamIpByType[$pnfType]:(-2)}
    [vendor]=${vendorsByType[$pnfType]^^}
    [timestamp]=${timestamp}
    [eventId]="${pnfIdByType[$pnfType]}_${modelByType[$pnfType]}"
    [eventTime]=${eventTime}
    [eventType]=EventType5G
)

echo "################################################################################";
echo "# send PNF registration";
echo;
for key in "${!mapping[@]}"
do
  #label=${${"$spaces$i"}:(-14)};
  label=$spaces$key;
  label=${label:(-16)};
  echo "$label: ${mapping[$key]}";
  if [ $key = "timestamp" ]; then
      sequence="$sequence s/\"@$key@\"/${mapping[$key]}/g; "
  else
      sequence="$sequence s/@$key@/${mapping[$key]}/g; "
  fi  
done
echo;

body="./json/examples/${pnfType^^}-${domain}.json"
sed -e "$sequence" ./json/templates/$domain.json > $body;

curl -i -u $basicAuthVes -X POST -d @${body} --header "Content-Type: application/json" $urlVes