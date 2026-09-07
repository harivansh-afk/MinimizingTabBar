#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
SIMULATOR_ID=${1:?Pass a simulator UUID from scripts/simulator.sh}
xcodebuild -project TabBarDemo.xcodeproj -scheme TabBarDemo \
  -destination "platform=iOS Simulator,id=$SIMULATOR_ID" -derivedDataPath build \
  -parallel-testing-enabled NO -only-testing:TabBarTests \
  -only-testing:TabBarUITests/TabBarUITests/testScrollAndNavigation test-without-building
