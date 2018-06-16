#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE

. config;
domain=heartbeat;

declare -A mapping=(
    [domain]=$domain
    [controllerName]=$(hostname --fqdn)
    [eventId]="$(hostname --fqdn)_${eventTime}"
    [eventType]="Controller"
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

body=./json/examples/${domain}.json
sed -e "$sequence" ./json/templates/$domain.json > $body;

curl -i -k -u $basicAuthVes -d @${body} --header "Content-Type: application/json" $urlVes