#!/bin/bash
################################################################################
# Script to demo interface tests

################################################################################
# send SDN-R heartbeat
./sendHeartbeat.sh

################################################################################
# create/update PNF in A%AI
./createPnf.sh 6352
./createPnf.sh MP06
./createPnf.sh MP20
./createPnf.sh MSS8
./createPnf.sh DWHQ
./createPnf.sh DWHC

################################################################################
# get PNF from A%AI
./getPnf.sh 6352
./getPnf.sh MP06
./getPnf.sh MP20
./getPnf.sh MSS8
./getPnf.sh DWHQ
./getPnf.sh DWHC

################################################################################
# raise fault
./sendFault.sh 6352 lossOfSignal CRITICAL
./sendFault.sh MP06 TCA MAJOR
./sendFault.sh MP20 TCA MINOR
./sendFault.sh MSS8 signalIsLost CRITICAL
./sendFault.sh DWHQ LossOfSignalAlarm CRITICAL
./sendFault.sh DWHC HAAMRunningInLowerModulation MAJOR
./sendFault.sh SDNR connectionLossNe MAJOR

################################################################################
# clear fault
./sendFault.sh 6352 lossOfSignal NORMAL
./sendFault.sh MP06 TCA NORMAL
./sendFault.sh MP20 TCA NORMAL
./sendFault.sh MSS8 signalIsLost NORMAL
./sendFault.sh DWHQ LossOfSignalAlarm NORMAL
./sendFault.sh DWHC HAAMRunningInLowerModulation NORMAL
./sendFault.sh SDNR connectionLossNe NORMAL

################################################################################
# raise threshold crossed alerts
./sendTca.sh 6352 TCA CONT
./sendTca.sh MP06 TCA SET
./sendTca.sh MP20 TCA CONT
./sendTca.sh MSS8 thresholdCrossed SET
./sendTca.sh DWHQ RSLBelowThreshold CONT
./sendTca.sh DWHC TCA SET

################################################################################
# clear threshold crossed alerts
./sendTca.sh 6352 TCA CLEAR
./sendTca.sh MP06 TCA CLEAR
./sendTca.sh MP20 TCA CLEAR
./sendTca.sh MSS8 thresholdCrossed CLEAR
./sendTca.sh DWHQ RSLBelowThreshold CLEAR
./sendTca.sh DWHC TCA CLEAR

################################################################################
# send 15min performance measurement data
./send15minPm.sh 6352
./send15minPm.sh MP06
./send15minPm.sh MP20
./send15minPm.sh MSS8
./send15minPm.sh DWHQ
./send15minPm.sh DWHC