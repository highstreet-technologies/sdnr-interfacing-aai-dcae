#!/bin/bash
################################################################################
# Script to create or update a pnf object in A&AI

. config

echo "################################################################################";
echo "# get all PNFs in A&AI;"
echo

curl -i -k -E $crt --key $key -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'X-FromAppId: SDNR' -H 'X-TransactionId: 9999' $urlAai/aai/v8/network/pnfs