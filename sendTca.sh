#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE

        timestamp=$(date -u +%s%3N);
        eventTime=$(date -u -d @${timestamp:0:$((${#timestamp}-3))} +'%Y-%m-%dT%H:%M:%S').${timestamp:(-3)}" UTC";
           time15=$(( $(date -u +%s) - $(($(date -u +%s) % 900))));
collectionEndTime=$(date -u -R -d @$time15 );
          eventId=$(uuidgen);
          pnfType=${1,,};
        alarmType=$2;
           action=$3;
           
declare -A severities=(
    [clear]=NORMAL
    [cont]=WARNING
    [set]=WARNING
)
         severity=${severities[${3,,}]};
    alarmInstance=$( echo "${pnfIdByType[$pnfType]}$alarmType$severity" | md5sum );
           spaces="                 ";
         sequence=;
. config;


declare -A mapping=(
    [controllerId]=${controllerId}
    [controllerName]=${controllerName}
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
    [collectionEndTime]=${collectionEndTime}
    [vendor]=${vendorsByType[$pnfType]}
)

echo;
for key in "${!mapping[@]}"
do
  label=$spaces$key;
  label=${label:(-17)};
  echo "$label: ${mapping[$key]}";
  sequence="$sequence s/@$key@/${mapping[$key]}/g; "
done
echo;

sed -e "$sequence" ./json/tca-body-template.json > ./json/tca-body.json

# json=$(< ./json/tca-body.json)
# echo "     body: $json"
# echo

curl -i -u $basicAuthVes -X POST -d  @json/tca-body.json --header "Content-Type: application/json" $urlVes