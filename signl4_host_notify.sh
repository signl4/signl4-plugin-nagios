#!/usr/bin/env bash

# Edit your SIGNL4 hook URL and use your own team secret
SIGNL4_URL=https://connect.signl4.com/webhook/<team-secret>

IFS='%'

# Nagios Host States: UP, DOWN, UNREACHABLE
# Nagios Notification Types: PROBLEM, RECOVERY, ACKNOWLEDGEMENT, FLAPPINGSTART, FLAPPINGSTOP, FLAPPINGDISABLED, DOWNTIMESTART, DOWNTIMEEND, DOWNTIMECANCELLED
SIGNL4_EXTID="HOST-$2"
SIGNL4_STATUS=""
if [ "$5" == "UP" ]; then
    SIGNL4_STATUS=", \"X-S4-STATUS\": \"resolved\""
fi
if [ "$1" == "RECOVERY" ]; then
    SIGNL4_STATUS=", \"X-S4-STATUS\": \"resolved\""
fi
if [ "$1" == "ACKNOWLEDGEMENT" ]; then
    SIGNL4_STATUS=", \"X-S4-STATUS\": \"acknowledged\""
fi
SIGNL4_MSG="{ \"Title\": \"$1 $SIGNL4_EXTID $4\", \"Host\": \"$2\", \"IP\": \"$3\", \"State\": \"$4\", \"Additional Info\":\"$5\", \"Nagios notification\": \"$6\", \"X-S4-SourceSystem\": \"Nagios\", \"X-S4-ExternalID\": \"$SIGNL4_EXTID\" $SIGNL4_STATUS }"

#Send message to SIGNL4
curl -L -X POST -H "Content-type: application/json" --data "$SIGNL4_MSG" $SIGNL4_URL

unset IFS
