#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE

. config;

declare -A mapping=(
    [controllerId]=${controllerId}
    [controllerName]=$(hostname --fqdn)
    [eventId]=${eventId}
    [timestamp]=${timestamp}
    [eventTime]=${eventTime}
)

echo "################################################################################";
echo "# send SDN-R heartbeat";
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

sed -e "$sequence" ./json/heartbeat-body-template.json > ./json/heartbeat-body.json

# json=$(< ./json/fault-body.json)
# echo "     body: $json"
# echo

curl -i -u $basicAuthVes -d @json/heartbeat-body.json --header "Content-Type: application/json" $urlVes