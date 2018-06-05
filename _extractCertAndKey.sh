#!/bin/bash
################################################################################
# Script to extract cert and key for A&AI interfacing
ä Please see https://wiki.web.att.com/pages/viewpage.action?spaceKey=SDNCDEV&title=Query+AAI+Using+Postman 
# for further information

mkdir -p certs
openssl pkcs12 -in /var/externals/data/stores/keystore.client.p12 -out certs/file.crt.pem -clcerts -nokeys
openssl pkcs12 -in /var/externals/data/stores/keystore.client.p12 -out certs/file.key.pem -nocerts -nodes

