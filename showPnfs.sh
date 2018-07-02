#!/bin/bash
################################################################################
# Script to create or update a pnf object in A&AI

. config

echo "################################################################################";
echo "# get all PNFs in A&AI;"
echo

echo "       URI: "$aaiUri
echo "   SSL Key: "$aaiSslKey
echo "Key phrase: "$aaiSslKeyPsswd
echo "    App-id: "$aaiAppId

echo
echo "Please wait ... Requesting all PNFs takes time!"

# curl -i -k -E $crt --key $key -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'X-FromAppId: SDNR' -H 'X-TransactionId: 9999' $urlAai/aai/v8/network/pnfs
./jcurl.sh -v -k -p12 $aaiSslKey $aaiSslKeyPsswd -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'X-FromAppId: $aaiAppId' -H 'X-TransactionId: 9999' $aaiUri/network/pnfs
