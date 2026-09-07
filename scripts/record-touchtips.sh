#!/bin/bash
set -euo pipefail
repo_root=$(cd "$(dirname "$0")/.." && pwd)
TOUCHTIPS_PATH=${1:?Pass the prepared TouchTips recording worktree path}
SIMULATOR_ID=${2:?Pass the dedicated TouchTips simulator UUID}
mkdir -p "$repo_root/media/raw" "$repo_root/build"
xcrun simctl status_bar "$SIMULATOR_ID" override --time '9:41' --dataNetwork wifi --wifiMode active --wifiBars 3 --batteryState charged --batteryLevel 100
log="$repo_root/build/touchtips-record.log"
xcodebuild -project "$TOUCHTIPS_PATH/TouchTips.xcodeproj" -scheme TouchTips \
  -destination "platform=iOS Simulator,id=$SIMULATOR_ID" -derivedDataPath "$TOUCHTIPS_PATH/build" \
  -parallel-testing-enabled NO -only-testing:TouchTipsUITests/TabBarRecordingUITests/testRecordTouchTips \
  test-without-building CODE_SIGNING_ALLOWED=NO > "$log" 2>&1 &
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
xcrun simctl io "$SIMULATOR_ID" recordVideo --codec=h264 --force "$repo_root/media/raw/simulator.mov" > "$repo_root/build/touchtips-capture.log" 2>&1 &
record_pid=$!
for ((i=0; i<120; i++)); do
  if grep -q RECORD_FINISHED "$log"; then break; fi
  if ! kill -0 "$test_pid" 2>/dev/null; then break; fi
  sleep 0.5
done
kill -INT "$record_pid"
wait "$record_pid" || true
record_pid=
wait "$test_pid"
grep -q RECORD_FINISHED "$log"
echo 'Recorded actual TouchTips footage in media/raw/simulator.mov'
