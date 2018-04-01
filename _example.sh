#!/bin/bash
################################################################################
# Script to demo interface tests

################################################################################
# send SDN-R heartbeat
./sendHeartbeat.sh

################################################################################
# create/update PNF in A%AI
./createPnf.sh 6352 lossOfSignal CRITICAL
./createPnf.sh MP06 TCA MAJOR
./createPnf.sh MP20 TCA MINOR
./createPnf.sh MSS8 signalIsLost CRITICAL
./createPnf.sh DWHQ LossOfSignalAlarm CRITICAL
./createPnf.sh DWHC HAAMRunningInLowerModulation MAJOR

################################################################################
# raise fault
./sendFault.sh 6352 lossOfSignal CRITICAL
./sendFault.sh MP06 TCA MAJOR
./sendFault.sh MP20 TCA MINOR
./sendFault.sh MSS8 signalIsLost CRITICAL
./sendFault.sh DWHQ LossOfSignalAlarm CRITICAL
./sendFault.sh DWHC HAAMRunningInLowerModulation MAJOR

################################################################################
# clear fault
./sendFault.sh 6352 lossOfSignal NORMAL
./sendFault.sh MP06 TCA NORMAL
./sendFault.sh MP20 TCA NORMAL
./sendFault.sh MSS8 signalIsLost NORMAL
./sendFault.sh DWHQ LossOfSignalAlarm NORMAL
./sendFault.sh DWHC HAAMRunningInLowerModulation NORMAL

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
# send 15min performance measuarment data
# to be done for 1810 ...