#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE

   timestamp=$(date -u +%s%3N);
   eventTime=$(date -u -d @${timestamp:0:$((${#timestamp}-3))} +'%Y-%m-%dT%H:%M:%S').${timestamp:(-3)}" UTC";
     eventId=$(uuidgen);
       spaces="                ";
     sequence=;
. config;

declare -A mapping=(
    [controllerId]=${controllerId}
    [controllerName]=${controllerName}
    [eventId]=${eventId}
    [timestamp]=${timestamp}
    [eventTime]=${eventTime}
)

echo;
for key in "${!mapping[@]}"
do
  #label=${${"$spaces$i"}:(-14)};
  label=$spaces$key;
  label=${label:(-16)};
  echo "$label: ${mapping[$key]}";
  sequence="$sequence s/@$key@/${mapping[$key]}/g; "
done
echo;

sed -e "$sequence" ./json/heartbeat-body-template.json > ./json/heartbeat-body.json

# json=$(< ./json/fault-body.json)
# echo "     body: $json"
# echo

curl -i -u $basicAuthVes -X POST -d  @json/heartbeat-body.json --header "Content-Type: application/json" $urlVes