#!/bin/bash
################################################################################
# Script to send an VES Message Event to DCAE

. config;
            pnfType=${1,,};
          alarmType=$2;
             action=$3;
             domain=thresholdCrossingAlert;
collectionTimestamp=$(date -u -R -d @$timeInS );:
          time15min=$(( $timeInS - $(($timeInS % 900))));
eventStartTimestamp=$(date -u -R -d @$time15min );

declare -A severities=(
    [clear]=NORMAL
    [cont]=WARNING
    [set]=WARNING
)
         severity=${severities[${3,,}]};

declare -A mapping=(
    [domain]=$domain
    [controllerName]=$(hostname --fqdn)
    [pnfId]=${pnfIdByType[$pnfType]}
    [eventId]="${pnfIdByType[$pnfType]}_${interfaceByType[$pnfType]}_${alarmType}"
    [eventType]=${eventType}
    [type]=${pnfType^^}
    [interface]=${interfaceByType[$pnfType]}
    [alarm]=${alarmType}
    [action]=${action}
    [severity]=${severity}
    [timestamp]=${timestamp}
    [eventTime]=${eventTime}
    [collectionTimestamp]=${collectionTimestamp}
    [eventStartTimestamp]=${eventStartTimestamp}
    [vendor]=${vendorsByType[$pnfType]^^}
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

body=./json/examples/${pnfType^^}-${alarmType}-${action}-${domain}.json;
sed -e "$sequence" ./json/templates/$domain.json > $body;

curl -i -k -u $basicAuthVes -X POST -d  @${body} --header "Content-Type: application/json" $urlVes