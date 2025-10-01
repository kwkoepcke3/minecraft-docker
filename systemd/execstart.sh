#!/bin/bash

set -euo pipefail

cleanup() {
  echo "[start.sh] caught termination signal... running execstop.sh"
  /bin/bash /opt/minecraft/run/systemd/execstop.sh 0
  exit 0
}

trap cleanup SIGTERM SIGINT

cd /opt/minecraft/run/minecraft

echo "[start.sh] starting minecraft server..."
if [ -r /opt/minecraft/run/minecraft/start.sh ] ; then
    /bin/bash /opt/minecraft/run/minecraft/start.sh &
else
    /bin/bash /opt/minecraft/run/minecraft/run.sh &
fi

PID=$!
wait $PID
EXIT_CODE=$?

echo "[KWK_DEBUG] ${EXIT_CODE}"

echo "[start.sh] server process exited!"
/bin/bash /opt/minecraft/run/systemd/execstop.sh $EXIT_CODE

exit $EXIT_CODE

