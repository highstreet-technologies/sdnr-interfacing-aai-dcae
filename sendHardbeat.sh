#!/bin/bash

eventId=$(uuidgen)
. config

sed -e "s/@pnfId@/${pnfIdByType[$pnfType]}/g; s/@eventId@/${eventId}/g; s/@controllerId@/${controllerId}/g; s/@controllerName@/${controllerName}/g; s/@pnfType@/${pnfType}/g; s/@interfaceId@/${interfaceByType[$pnfType]}/g; s/@alarmType@/${alarmType}/g; s/@severity@/${severity}/g; s/\"@timestamp@\"/$(($(date +%s%N)/1000000))/g; " ./json/heartbeat-body-template.json > ./json/heartbeat-body.json

echo
echo "  controllerId: ${controllerId}"
echo "controllerName: ${controllerName}"
echo "     timestamp: $(($(date +%s%N)/1000000))"
echo "       eventId: ${eventId}"
echo 
# json=$(< ./json/heartbeat-body.json)
# echo "     body: $json"
# echo

curl -i -u $basicAuthVes -X POST -d  @json/heartbeat-body.json --header "Content-Type: application/json" $dcaeUrl