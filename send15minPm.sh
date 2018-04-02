#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE

          timestamp=$(date -u +%s%3N);
            timeInS=${timestamp:0:$((${#timestamp}-3))};
             timeMs=${timestamp:(-3)};
          eventTime=$(date -u -d @${timestamp:0:$((${#timestamp}-3))} +'%Y-%m-%dT%H:%M:%S').${timestamp:(-3)}" UTC";
   
   collectionEndTime=$(( $(date -u +%s) - $(($(date -u +%s) % 900))));
 collectionStartTime=$(( collectionEndTime - 900 ));

            eventId=$(uuidgen);
            pnfType=${1,,};
. config;


declare -A mapping=(
    [controllerId]=${controllerId}
    [controllerName]=$(hostname --fqdn)
    [pnfId]=${pnfIdByType[$pnfType]}
    [eventId]=${eventId}
    [type]=${pnfType^^}
    [interface]=${interfaceByType[$pnfType]}
    [timestamp]=${timestamp}
    [eventTime]=${eventTime}
    [collectionStartTime]=${collectionStartTime}000
    [collectionEndTime]=${collectionEndTime}000
    [intervalStartTime]=$(date -u -R -d @$collectionStartTime )
    [intervalEndTime]=$(date -u -R -d @$collectionEndTime )
    [vendor]=${vendorsByType[$pnfType]}
    [model]=${modelByType[$pnfType]}
)

echo "################################################################################";
echo "# send 15min performance values";
echo
for key in "${!mapping[@]}"
do
  label=$spaces$key;
  label=${label:(-20)};
  echo "$label: ${mapping[$key]}";
  if [ $key = "collectionStartTime" ] || [ $key = "collectionEndTime" ]; then
      sequence="$sequence s/\"@$key@\"/${mapping[$key]}/g; "
  else
      sequence="$sequence s/@$key@/${mapping[$key]}/g; "
  fi  
done
echo;

sed -e "$sequence" ./json/measurement-body-template.json > ./json/measurement-body.json

# json=$(< ./json/measurement-body.json)
# echo "     body: $json"
# echo

curl -i -u $basicAuthVes -X POST -d  @json/measurement-body.json --header "Content-Type: application/json" $urlVes