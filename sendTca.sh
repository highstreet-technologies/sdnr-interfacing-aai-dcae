#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE

. config;
            pnfType=${1,,};
          alarmType=$2;
             action=$3;
collectionTimestamp=$(date -u -R -d @$timeInS );:
          time15min=$(( $timeInS - $(($timeInS % 900))));
eventStartTimestamp=$(date -u -R -d @$time15min );

declare -A severities=(
    [clear]=NORMAL
    [cont]=WARNING
    [set]=WARNING
)
         severity=${severities[${3,,}]};
    alarmInstance=$( echo "${pnfIdByType[$pnfType]}$alarmType$severity" | md5sum );


declare -A mapping=(
    [controllerName]=$(hostname --fqdn)
    [pnfId]=${pnfIdByType[$pnfType]}
    [eventId]=${eventId}
    [alarmInstance]=${alarmInstance}
    [type]=${pnfType^^}
    [interface]=${interfaceByType[$pnfType]}
    [alarm]=${alarmType}
    [action]=${action}
    [severity]=${severity}
    [timestamp]=${timestamp}
    [eventTime]=${eventTime}
    [collectionTimestamp]=${collectionTimestamp}
    [eventStartTimestamp]=${eventStartTimestamp}
    [vendor]=${vendorsByType[$pnfType]}
    [model]=${modelByType[$pnfType]}
)

echo "################################################################################";
echo "# send threshold crossed alert";
echo
for key in "${!mapping[@]}"
do
  label=$spaces$key;
  label=${label:(-20)};
  echo "$label: ${mapping[$key]}";
  if [ $key = "timestamp" ]; then
      sequence="$sequence s/\"@$key@\"/${mapping[$key]}/g; "
  else
      sequence="$sequence s/@$key@/${mapping[$key]}/g; "
  fi  
done
echo;

sed -e "$sequence" ./json/tca-body-template.json > ./json/tca-body.json

# json=$(< ./json/tca-body.json)
# echo "     body: $json"
# echo

curl -i -u $basicAuthVes -X POST -d  @json/tca-body.json --header "Content-Type: application/json" $urlVes