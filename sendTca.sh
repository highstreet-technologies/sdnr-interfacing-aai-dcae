#!/bin/bash

pnfType=$1
action=$2
eventId=$(uuidgen)
. config

// dt=$(date -u '+%d/%m/%Y %H:%M:%S');

sed -e "s/@pnfId@/${pnfIdByType[$pnfType]}/g; s/@eventId@/${eventId}/g; s/@controllerId@/${controllerId}/g; s/@controllerName@/${controllerName}/g; s/@pnfType@/${pnfType}/g; s/@interfaceId@/${interfaceByType[$pnfType]}/g; s/@action@/${action}/g; s/\"@timestamp@\"/$(($(date -u +%s%N)/1000000))/g; s/@collectionEndTime@/${collectionEndTime}/g;  " ./json/tca-body-template.json > ./json/tca-body.json

echo
echo "     controllerId: ${controllerId}"
echo "   controllerName: ${controllerName}"
echo "            pnfId: ${pnfIdByType[$pnfType]}"
echo "             type: ${pnfType}"
echo "           vendor: ${vendorsByType[$pnfType]}"
echo "        interface: ${interfaceByType[$pnfType]}"
echo "           action: ${action}"
echo "        timestamp: $(($(date -u +%s%N)/1000000))"
echo "collectionEndTime: $(date -u)"
echo "          eventId: ${eventId}"
echo 
# json=$(< ./json/tca-body.json)
# echo "     body: $json"
# echo

curl -i -u $basicAuthVes -X POST -d  @json/tca-body.json --header "Content-Type: application/json" $dcaeUrl