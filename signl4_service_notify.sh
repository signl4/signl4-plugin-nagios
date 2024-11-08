#!/usr/bin/env bash

# Edit your SIGNL4 hook URL and use your own team secret
SIGNL4_URL=https://connect.signl4.com/webhook/<team-secret>

IFS='%'

# Nagios States: OK, CRITICAL, WARNING, UNKNOWN
# Nagios Notification Types: PROBLEM, RECOVERY, ACKNOWLEDGEMENT, FLAPPINGSTART, FLAPPINGSTOP, FLAPPINGDISABLED, DOWNTIMESTART, DOWNTIMEEND, DOWNTIMECANCELLED
SIGNL4_EXTID="SVC-$2-$4"
echo "5 is $5"
SIGNL4_STATUS=""
if [[ "$5" == "OK" ]]; then
    SIGNL4_STATUS=", \"X-S4-STATUS\": \"resolved\""
fi
if [[ "$1" == "RECOVERY" ]]; then
    SIGNL4_STATUS=", \"X-S4-STATUS\": \"resolved\""
fi
if [[ "$1" == "ACKNOWLEDGEMENT" ]]; then
    SIGNL4_STATUS=", \"X-S4-STATUS\": \"acknowledged\""
fi
SIGNL4_MSG="{ \"Title\": \"$1 $SIGNL4_EXTID\", \"Host\": \"$2\", \"IP\": \"$3\", \"Service\": \"$4\", \"State\": \"$5\", \"Additional Info\":\"$6\", \"Nagios notification\": \"$7\", \"X-S4-SourceSystem\": \"Nagios\", \"X-S4-ExternalID\": \"$SIGNL4_EXTID\" $SIGNL4_STATUS }"

#Send message to SIGNL4
curl -L -X POST -H "Content-type: application/json" --data "$SIGNL4_MSG" $SIGNL4_URL

unset IFS
~
