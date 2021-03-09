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
    [type]=${pnfType^^}
    [interface]=${interfaceByType[$pnfType]}
    [model]=${modelByType[$pnfType]}
    [oamIp]=${oamIpByType[$pnfType]}
    [vendor]=${vendorsByType[$pnfType]^^}
)

echo "################################################################################";
echo "# create or update PNF in A&AI";
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

body=./json/examples/${pnfType^^}-pnf.json
sed -e "$sequence" ./json/templates/pnf.json > $body

curl -v -k -p12 $aaiSslKey $aaiSslKeyPsswd -X PUT -d  @${body} -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'X-FromAppId: SDNR' -H 'X-TransactionId: 9999' $urlAai/network/pnfs/pnf/${pnfIdByType[$pnfType]}
