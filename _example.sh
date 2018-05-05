#!/bin/bash
################################################################################
# Script to demo interface tests

################################################################################
# send SDN-R heartbeat
./sendHeartbeat.sh

################################################################################
# pnfRegistration event to DCAE for ONAP Beijing 
./pnfRegister.sh 6352 Beijing
./pnfRegister.sh MP06 Beijing
./pnfRegister.sh MP20 Beijing
./pnfRegister.sh MSS8 Beijing
./pnfRegister.sh DWHQ Beijing
./pnfRegister.sh DWHC Beijing
./pnfRegister.sh NO5G Beijing
./pnfRegister.sh ER5G Beijing
./pnfRegister.sh CSOC Beijing
./pnfRegister.sh CSIE Beijing

################################################################################
# pnfRegistration event to DCAE for ONAP Casablanca 
./pnfRegister.sh 6352 Casablanca
./pnfRegister.sh MP06 Casablanca
./pnfRegister.sh MP20 Casablanca
./pnfRegister.sh MSS8 Casablanca
./pnfRegister.sh DWHQ Casablanca
./pnfRegister.sh DWHC Casablanca
./pnfRegister.sh NO5G Casablanca
./pnfRegister.sh ER5G Casablanca
./pnfRegister.sh CSOC Casablanca
./pnfRegister.sh CSIE Casablanca

################################################################################
# create/update PNF in A&AI
./createPnf.sh 6352
./createPnf.sh MP06
./createPnf.sh MP20
./createPnf.sh MSS8
./createPnf.sh DWHQ
./createPnf.sh DWHC
./createPnf.sh NO5G
./createPnf.sh ER5G
./createPnf.sh CSOC
./createPnf.sh CSIE

################################################################################
# raise fault
./sendFault.sh 6352 lossOfSignal CRITICAL
./sendFault.sh MP06 TCA MAJOR
./sendFault.sh MP20 TCA MINOR
./sendFault.sh MSS8 signalIsLost CRITICAL
./sendFault.sh DWHQ LossOfSignalAlarm CRITICAL
./sendFault.sh DWHC HAAMRunningInLowerModulation MAJOR
./sendFault.sh SDNR connectionLossNe MAJOR
./sendFault.sh NO5G signalIsLost CRITICAL
./sendFault.sh ER5G LossOfSignalAlarm MAJOR
./sendFault.sh CSOC HAAMRunningInLowerModulation MAJOR
./sendFault.sh CSIE connectionLossNe CRITICAL

################################################################################
# clear fault
./sendFault.sh 6352 lossOfSignal NORMAL
./sendFault.sh MP06 TCA NORMAL
./sendFault.sh MP20 TCA NORMAL
./sendFault.sh MSS8 signalIsLost NORMAL
./sendFault.sh DWHQ LossOfSignalAlarm NORMAL
./sendFault.sh DWHC HAAMRunningInLowerModulation NORMAL
./sendFault.sh SDNR connectionLossNe NORMAL
./sendFault.sh NO5G signalIsLost NORMAL
./sendFault.sh ER5G LossOfSignalAlarm NORMAL
./sendFault.sh CSOC HAAMRunningInLowerModulation NORMAL
./sendFault.sh CSIE connectionLossNe NORMAL

################################################################################
# raise threshold crossed alerts
./sendTca.sh 6352 TCA CONT
./sendTca.sh MP06 TCA SET
./sendTca.sh MP20 TCA CONT
./sendTca.sh MSS8 thresholdCrossed SET
./sendTca.sh DWHQ RSLBelowThreshold CONT
./sendTca.sh DWHC TCA SET
./sendTca.sh NO5G TCA CONT
./sendTca.sh ER5G thresholdCrossed SET
./sendTca.sh CSOC RSLBelowThreshold CONT
./sendTca.sh CSIE TCA SET

################################################################################
# clear threshold crossed alerts
./sendTca.sh 6352 TCA CLEAR
./sendTca.sh MP06 TCA CLEAR
./sendTca.sh MP20 TCA CLEAR
./sendTca.sh MSS8 thresholdCrossed CLEAR
./sendTca.sh DWHQ RSLBelowThreshold CLEAR
./sendTca.sh DWHC TCA CLEAR
./sendTca.sh NO5G TCA CLEAR
./sendTca.sh ER5G thresholdCrossed CLEAR
./sendTca.sh CSOC RSLBelowThreshold CLEAR
./sendTca.sh CSIE TCA CLEAR

################################################################################
# send 15min performance measurement data
./send15minPm.sh 6352
./send15minPm.sh MP06
./send15minPm.sh MP20
./send15minPm.sh MSS8
./send15minPm.sh DWHQ
./send15minPm.sh DWHC
./send15minPm.sh NO5G
./send15minPm.sh ER5G
./send15minPm.sh CSOC
./send15minPm.sh CSIE