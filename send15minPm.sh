#!/bin/bash

pnfType=$1
alarmType=$2
severity=$3
eventId=$(uuidgen)
. config

sed -e "s/@pnfId@/${pnfIdByType[$pnfType]}/g; s/@eventId@/${eventId}/g; s/@controllerId@/${controllerId}/g; s/@controllerName@/${controllerName}/g; s/@pnfType@/${pnfType}/g; s/@interfaceId@/${interfaceByType[$pnfType]}/g; s/@alarmType@/${alarmType}/g; s/@severity@/${severity}/g; s/\"@timestamp@\"/$(($(date -u +%s%N)/1000000))/g; " ./json/measurement-body-template.json > ./json/measurement-body.json

echo "################################################################################";
echo "# send 15min performance monitoring";
echo
echo "  controllerId: ${controllerId}"
echo "controllerName: ${controllerName}"
echo "         pnfId: ${pnfIdByType[$pnfType]}"
echo "          type: ${pnfType}"
echo "        vendor: ${vendorsByType[$pnfType]}"
echo "     interface: ${interfaceByType[$pnfType]}"
echo "         alarm: ${alarmType}"
echo "     timestamp: $(($(date -u +%s%N)/1000000))"
echo "       eventId: ${eventId}"
echo 
# json=$(< ./json/measurement-body.json)
# echo "     body: $json"
# echo

curl -i -u $basicAuthVes -X POST -d  @json/measurement-body.json --header "Content-Type: application/json" $urlVes