#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE

   timestamp=$(date -u +%s%3N);
   eventTime=$(date -u -d @${timestamp:0:$((${#timestamp}-3))} +'%Y-%m-%dT%H:%M:%S').${timestamp:(-3)}" UTC";
     eventId=$(uuidgen);
     pnfType=${1,,};
    alarmType=$2;
     severity=$3;
alarmInstance=$( echo "${pnfIdByType[$pnfType]}$alarmType$severity" | md5sum );
. config;

declare -A mapping=(
    [controllerId]=${controllerId}
    [controllerName]=$(hostname --fqdn)
    [pnfId]=${pnfIdByType[$pnfType]}
    [eventId]=${eventId}
    [alarmInstance]=${alarmInstance}
    [type]=${pnfType^^}
    [interface]=${interfaceByType[$pnfType]}
    [alarm]=${alarmType}
    [severity]=${severity}
    [timestamp]=${timestamp}
    [eventTime]=${eventTime}
    [vendor]=${vendorsByType[$pnfType]}
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

sed -e "$sequence" ./json/fault-body-template.json > ./json/fault-body.json

# json=$(< ./json/fault-body.json)
# echo "     body: $json"
# echo

curl -i -u $basicAuthVes -X POST -d @json/fault-body.json --header "Content-Type: application/json" $urlVes