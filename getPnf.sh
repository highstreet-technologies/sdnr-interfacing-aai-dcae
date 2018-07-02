#!/bin/bash
################################################################################
# Script to create or update a pnf object in A&AI

pnfType=${1,,};
. config

declare -A mapping=(
    [pnfId]=${pnfIdByType[$pnfType]}
)

echo "################################################################################";
echo "# get PNF by name from A&AI;"
echo

echo "       URI: "$aaiUri
echo "   SSL Key: "$aaiSslKey
echo "Key phrase: "$aaiSslKeyPsswd
echo "    App-id: "$aaiAppId

for key in "${!mapping[@]}"
do
  label=$spaces$key;
  label=${label:(-20)};
  echo "$label: ${mapping[$key]}";
  sequence="$sequence s/@$key@/${mapping[$key]}/g; "
done
echo;

# curl -i -k -E $crt --key $key -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'X-FromAppId: SDNR' -H 'X-TransactionId: 9999' $urlAai/aai/v8/network/pnfs
./jcurl.sh -v -k -p12 $aaiSslKey $aaiSslKeyPsswd -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'X-FromAppId: $aaiAppId' -H 'X-TransactionId: 9999' $aaiUri/network/pnfs/pnf/${pnfIdByType[$pnfType]}"
