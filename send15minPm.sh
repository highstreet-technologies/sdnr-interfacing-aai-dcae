#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE
   
. config;
            pnfType=${1,,};
   collectionEndTime=$(( $timeInS - $(($timeInS % 900))));
 collectionStartTime=$(( collectionEndTime - 900 ));
 
declare -A mapping=(
    [controllerName]=$(hostname --fqdn)
    [pnfId]=${pnfIdByType[$pnfType]}
    [eventId]="${pnfIdByType[$pnfType]}_${collectionEndTime}_15min"
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