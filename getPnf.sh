#!/bin/bash
################################################################################
# Script to create or update a pnf object in A&AI

pnfType=${1,,};
. config

declare -A mapping=(
    [pnfId]=${pnfIdByType[$pnfType]}
)

echo "################################################################################";
echo "# get all PNF by name from A&AI;"
echo

echo "   SSL Key: "$aaiSslKey
echo "Key phrase: "$aaiSslKeyPsswd
echo "    App-id: "$aaiAppId
echo "       URI: "$aaiUri
echo "   Version: "$aaiApiVersion

for key in "${!mapping[@]}"
do
  label=$spaces$key;
  label=${label:(-20)};
  echo "$label: ${mapping[$key]}";
  sequence="$sequence s/@$key@/${mapping[$key]}/g; "
done
echo;

echo
echo "Please wait ... Requesting all PNFs takes time!"

# curl -i -k -E $crt --key $key -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'X-FromAppId: SDNR' -H 'X-TransactionId: 9999' $urlAai/aai/v8/network/pnfs
./jcurl.sh -v -k -p12 $aaiSslKey $aaiSslKeyPsswd -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'X-FromAppId: $aaiAppId' -H 'X-TransactionId: 9999' $aaiUri/$aaiApiVersion/network/pnfs/pnf/${pnfIdByType[$pnfType]}"
