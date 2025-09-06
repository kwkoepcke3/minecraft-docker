#!/bin/bash

set -euo pipefail

cleanup() {
  echo "[start.sh] caught termination signal... running execstop.sh"
  /bin/bash /opt/minecraft/run/systemd/execstop.sh
  exit 0
}

trap cleanup SIGTERM SIGINT

echo "[start.sh] starting minecraft server..."
/bin/bash /opt/minecraft/run/minecraft/start.sh &

PID=$!
wait $PID
EXIT_CODE=$?

echo "[start.sh] server process exited!"
/bin/bash /opt/minecraft/run/systemd/execstop.sh

exit $EXIT_CODE
