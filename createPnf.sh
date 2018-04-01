#!/bin/bash
################################################################################
# Script to create or update a pnf object in A&AI

pnfType=${1,,};
. config

declare -A mapping=(
    [pnfId]=${pnfIdByType[$pnfType]}
    [type]=${pnfType^^}
    [model]=${modelByType[$pnfType]}
    [oamIp]=${oamIpByType[$pnfType]}
    [vendor]=${vendorsByType[$pnfType]}
)

echo "################################################################################";
echo "# create or update PNF in A%AI";
echo
for key in "${!mapping[@]}"
do
  label=$spaces$key;
  label=${label:(-17)};
  echo "$label: ${mapping[$key]}";
  sequence="$sequence s/@$key@/${mapping[$key]}/g; "
done
echo;

sed -e "$sequence" ./json/pnf-body-template.json > ./json/pnf-body.json

curl -i -u $basicAuthAai -X PUT -d  @json/pnf-body.json -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'X-FromAppId: SDNR' -H 'X-TransactionId: 9999' $urlAai/aai/v8/network/pnfs/pnf/${pnfIdByType[$pnfType]}