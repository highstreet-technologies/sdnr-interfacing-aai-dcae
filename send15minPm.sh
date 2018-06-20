#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE
   
. config;
             pnfType=${1,,};
              domain="measurementsForVfScaling";
   collectionEndTime=$(( $timeInS - $(($timeInS % 900))));
 collectionStartTime=$(( collectionEndTime - 900 ));
         granularity="PM15min";
 
declare -A mapping=(
    [domain]=$domain
    [controllerName]=$(hostname --fqdn)
    [pnfId]=${pnfIdByType[$pnfType]}
    [granularity]=$granularity
    [eventId]="${pnfIdByType[$pnfType]}_${collectionEndTime}_${granularity}"
    [eventType]=${eventType}
    [type]=${pnfType^^}
    [interface]=${interfaceByType[$pnfType]}
    [timestamp]=${timestamp}
    [eventTime]=${eventTime}
    [collectionStartTime]=${collectionStartTime}000
    [collectionEndTime]=${collectionEndTime}000
    [intervalStartTime]=$(date -u -R -d @$collectionStartTime )
    [intervalEndTime]=$(date -u -R -d @$collectionEndTime )
    [vendor]=${vendorsByType[$pnfType]^^}
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

body=./json/examples/${pnfType^^}-${domain}.json
sed -e "$sequence" ./json/templates/$domain.json > $body

curl -i -k -u $basicAuthVes -X POST -d  @${body} --header "Content-Type: application/json" $urlVes