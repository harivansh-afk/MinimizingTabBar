#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
SIMULATOR_ID=${1:?Pass the UUID of the dedicated demo simulator}
mkdir -p media/raw build
xcrun simctl status_bar "$SIMULATOR_ID" override --time '9:41' --dataNetwork wifi --wifiMode active --wifiBars 3 --batteryState charged --batteryLevel 100
log=build/record.log
xcodebuild -project TabBarDemo.xcodeproj -scheme TabBarDemo \
  -destination "platform=iOS Simulator,id=$SIMULATOR_ID" -derivedDataPath build \
  -parallel-testing-enabled NO -only-testing:TabBarUITests/TabBarUITests/testRecordDemo \
  test-without-building > "$log" 2>&1 &
test_pid=$!
record_pid=
cleanup() {
  if [[ -n "$record_pid" ]]; then kill -INT "$record_pid" 2>/dev/null || true; fi
}
trap cleanup EXIT
for ((i=0; i<90; i++)); do
  if grep -q RECORD_READY "$log"; then break; fi
  if ! kill -0 "$test_pid" 2>/dev/null; then cat "$log"; exit 1; fi
  sleep 1
done
grep -q RECORD_READY "$log" || { kill "$test_pid"; echo 'Capture marker timed out'; exit 1; }
xcrun simctl io "$SIMULATOR_ID" recordVideo --codec=h264 --force media/raw/simulator.mov > build/capture.log 2>&1 &
record_pid=$!
for ((i=0; i<60; i++)); do
  if grep -q RECORD_FINISHED "$log"; then break; fi
  if ! kill -0 "$test_pid" 2>/dev/null; then break; fi
  sleep 0.5
done
kill -INT "$record_pid"
wait "$record_pid" || true
record_pid=
wait "$test_pid"
grep -q RECORD_FINISHED "$log"
echo 'Recorded media/raw/simulator.mov'
