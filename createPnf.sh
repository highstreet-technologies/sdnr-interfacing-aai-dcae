#!/bin/bash
################################################################################
# Script to create or update a pnf object in A&AI

pnfType=${1,,};
. config

declare -A mapping=(
    [pnfId]=${pnfIdByType[$pnfType]}
    [type]=${pnfType^^}
    [interface]=${interfaceByType[$pnfType]}
    [model]=${modelByType[$pnfType]}
    [oamIp]=${oamIpByType[$pnfType]}
    [vendor]=${vendorsByType[$pnfType]^^}
)

echo "################################################################################";
echo "# create or update PNF in A&AI";
echo
for key in "${!mapping[@]}"
do
  label=$spaces$key;
  label=${label:(-20)};
  echo "$label: ${mapping[$key]}";
  sequence="$sequence s/@$key@/${mapping[$key]}/g; "
done
echo;

body=./json/examples/${pnfType^^}-pnf.json
sed -e "$sequence" ./json/templates/pnf.json > $body

./jcurl.sh -v -k -p12 $aaiSslKey $aaiSslKeyPsswd -X PUT -d  @${body} -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'X-FromAppId: SDNR' -H 'X-TransactionId: 9999' $urlAai/$aaiApiVersion/network/pnfs/pnf/${pnfIdByType[$pnfType]}