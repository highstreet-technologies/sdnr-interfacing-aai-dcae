#!/bin/bash
################################################################################
#
# Copyright 2019 highstreet technologies GmbH and others
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
curl -v -k -p12 $aaiSslKey $aaiSslKeyPsswd -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'X-FromAppId: $aaiAppId' -H 'X-TransactionId: 9999' $aaiUri/network/pnfs/pnf/${pnfIdByType[$pnfType]}"
