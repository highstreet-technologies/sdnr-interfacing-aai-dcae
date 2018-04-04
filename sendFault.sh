#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE

. config;
     pnfType=${1,,};
    alarmType=$2;
     severity=$3;

declare -A mapping=(
    [controllerName]=$(hostname --fqdn)
    [pnfId]=${pnfIdByType[$pnfType]}
    [eventId]="${pnfIdByType[$pnfType]}_${interfaceByType[$pnfType]}_${alarmType}"
    [type]=${pnfType^^}
    [interface]=${interfaceByType[$pnfType]}
    [alarm]=${alarmType}
    [severity]=${severity}
    [timestamp]=${timestamp}
    [eventTime]=${eventTime}
    [vendor]=${vendorsByType[$pnfType]}
    [model]=${modelByType[$pnfType]}
)

echo "################################################################################";
echo "# send fault";
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

body="./json/examples/${pnfType^^}-${alarmType}-${severity}-fault.json"
sed -e "$sequence" ./json/templates/fault.json > $body;

curl -i -u $basicAuthVes -X POST -d @${body} --header "Content-Type: application/json" $urlVes