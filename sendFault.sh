#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE

. config;
      pnfType=${1,,};
    alarmType=$2;
     severity=$3;
       domain="fault";

# exception for controller alarms
if [ "${pnfType^^}" == "SDNR" ]
  then
    eventType="ONAP_SDNR_Controller";
fi

declare -A mapping=(
    [domain]=$domain
    [controllerName]=$(hostname --fqdn)
    [pnfId]=${pnfIdByType[$pnfType]}
    [eventId]="${pnfIdByType[$pnfType]}_${interfaceByType[$pnfType]}_${alarmType}"
    [eventType]=${eventType}
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

body="./json/examples/${pnfType^^}-${alarmType}-${severity}-${domain}.json"
sed -e "$sequence" ./json/templates/$domain.json > $body;

curl -i -u $basicAuthVes -X POST -d @${body} --header "Content-Type: application/json" $urlVes