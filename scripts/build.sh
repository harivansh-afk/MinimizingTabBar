#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
SIMULATOR_ID=${1:?Pass a simulator UUID from scripts/simulator.sh}
xcodebuild -project TabBarDemo.xcodeproj -scheme TabBarDemo \
  -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
  -derivedDataPath build -quiet build-for-testing
