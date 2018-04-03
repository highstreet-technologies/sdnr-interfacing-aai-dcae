# SDN-R interfaceing with DCAE and A&AI

Test scripts for interfaceing with DCAE and A&AI.

For 1806 the interface definition with DCAE is: [CommonEventFormat_28.4.1.json](./json/schema/CommonEventFormat_28.4.1.json).
For 1806 the interface definition with A&AI is: [add link when known]().

## Prerequisites

This git project must be cloned on a ubuntu maschine in order to execute the bash scripts.
DCAE and A&AI provide REST interfaces. In order to perform HTTP request [cURL](https://curl.haxx.se/) is used. 

In case cURL needs to be please use the following command in a terminal.

```
sudo apt-get install curl 
```

It is nessary to configure the DCAE and A&AI servers for valid excecution of the bash scripts.
Please update the varables in [config](-/config) accordintly to the test enviroment.

```
controllerId=46fa9a9a-5e1f-4286-8035-cb0df44e907a
controllerName=zltcmtn23arbc01.2f0377.mtn23a.tci.att.com
urlAai=http://localhost:8447/aai
basicAuthAai=AAI:AAI
urlVes=http://localhost:8443/eventListener/v3
basicAuthVes=ves:ves
```

## Concept

Several tests scripts are avialable in the root of this project. 
The bash scripts will perform a cURL command to send a REST request to the A&AI or DCAE server.

![SDN-R NBIs](./images/sdnr-nbis.png "SDN-R NBIs")

## Scripts

This chapter descibes the several test scripts its usage and functions.

### _example

This scripts calls all the other scripts in order to give valid examples and to expain by examples the usage ot the other scripts.

```
./_example.sh 
```

Please see valid examples using the followfing command (or continue reading):

```
cat _example.sh 
```

### createPnf

The script creates a PNF object in A&AI. The script requires one input parameter. This parameter defines the equipment type. Valid equipment types for 1806 and 1810 are [6352, MP06, MP20, MSS8, DWHQm, DWHC] according to document "295672 SDN-R System Requirements".

```
./createPnf.sh MSS8
```

### sendHeartbeat

The script sends a "heardbeat" from SDN-R to DCAE.

The following example show the usage of this script:
```
./sendHeartbeat.sh
```


### sendFault

This script send a VES message of domain "fault" to DCAE. It requires three command line parameters:

1. **equipmentType**: Valid equipment types for 1806 and 1810 are [6352, MP06, MP20, MSS8, DWHQm, DWHC] according to document "295672 SDN-R System Requirements".

2. **alarmType**: or alarm name. Any string which references a supported alarm name of the equipment type.

3. **severity**: The severity of tha alarm as defined by [VES schema](./json/schema/CommonEventFormat_28.4.1.json). 

The following example show the usage of this script. The alarm "lossOfSignal" for equipment type "DWHQ" with severtiy "CRITICAL" will be send.

```
./sendFault.sh DWHQ lossOfSignal CRITICAL
```


### sendTca

This script send a VES message of domain "thresholdCrossingAlert" to DCAE. It requires three command line parameters:

1. **equipmentType**: Valid equipment types for 1806 and 1810 are [6352, MP06, MP20, MSS8, DWHQm, DWHC] according to document "295672 SDN-R System Requirements".

2. **alarmType**: or alarm name. Any string which references a supported alarm name (TCA) of the equipment type.

3. **alertAction**: The action of tha TCA as defined by [VES schema](./json/schema/CommonEventFormat_28.4.1.json). 

The following example show the usage of this script. The TCA with name "TCA" for equipment type "6352" with alarmAction "SET" will be send.

```
./sendTca.sh 6352 TCA SET
```


### send15minPm

This script send a VES message of domain "measurementsForVfScaling" to DCAE. The script requires one input parameter. This parameter defines the equipment type. Valid equipment types for 1806 and 1810 are [6352, MP06, MP20, MSS8, DWHQm, DWHC] according to document "295672 SDN-R System Requirements".

```
./send15minPm.sh MP06
```
